using System.Diagnostics;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace DotNetMetrics.Console;

public class ProcessMetrics
{
    [JsonPropertyName("timestamp")]
    public DateTime Timestamp { get; set; }
    
    [JsonPropertyName("processId")]
    public int ProcessId { get; set; }
    
    [JsonPropertyName("processName")]
    public string ProcessName { get; set; } = string.Empty;
    
    [JsonPropertyName("cpuUsagePercent")]
    public double CpuUsagePercent { get; set; }
    
    [JsonPropertyName("memoryUsageMB")]
    public double MemoryUsageMB { get; set; }
    
    [JsonPropertyName("workingSetMB")]
    public double WorkingSetMB { get; set; }
    
    [JsonPropertyName("privateMemoryMB")]
    public double PrivateMemoryMB { get; set; }
}

public class ProcessMonitor
{
    private readonly int _processId;
    private readonly Process? _process;
    private DateTime _lastCpuTime;
    private TimeSpan _lastTotalProcessorTime;
    private readonly object _lock = new();

    public ProcessMonitor(int processId)
    {
        _processId = processId;
        try
        {
            _process = Process.GetProcessById(processId);
            _lastCpuTime = DateTime.UtcNow;
            _lastTotalProcessorTime = _process.TotalProcessorTime;
        }
        catch (ArgumentException)
        {
            throw new ArgumentException($"Process with PID {processId} not found.");
        }
        catch (InvalidOperationException ex)
        {
            throw new InvalidOperationException($"Cannot access process with PID {processId}: {ex.Message}");
        }
    }

    public ProcessMetrics GetMetrics()
    {
        if (_process == null || _process.HasExited)
        {
            throw new InvalidOperationException("Process does not exist or has been terminated.");
        }

        lock (_lock)
        {
            try
            {
                _process.Refresh();

                var currentTime = DateTime.UtcNow;
                var currentTotalProcessorTime = _process.TotalProcessorTime;

                // Calculate CPU usage
                var cpuUsedMs = (currentTotalProcessorTime - _lastTotalProcessorTime).TotalMilliseconds;
                var totalMsPassed = (currentTime - _lastCpuTime).TotalMilliseconds;
                var cpuUsageTotal = cpuUsedMs / (Environment.ProcessorCount * totalMsPassed);
                var cpuUsagePercent = cpuUsageTotal * 100;

                // Update values for next measurement
                _lastCpuTime = currentTime;
                _lastTotalProcessorTime = currentTotalProcessorTime;

                return new ProcessMetrics
                {
                    Timestamp = currentTime,
                    ProcessId = _processId,
                    ProcessName = _process.ProcessName,
                    CpuUsagePercent = Math.Round(Math.Max(0, Math.Min(100, cpuUsagePercent)), 2),
                    MemoryUsageMB = Math.Round(_process.PagedMemorySize64 / (1024.0 * 1024.0), 2),
                    WorkingSetMB = Math.Round(_process.WorkingSet64 / (1024.0 * 1024.0), 2),
                    PrivateMemoryMB = Math.Round(_process.PrivateMemorySize64 / (1024.0 * 1024.0), 2)
                };
            }
            catch (Exception ex) when (ex is InvalidOperationException || ex is System.ComponentModel.Win32Exception)
            {
                throw new InvalidOperationException($"Error retrieving process metrics: {ex.Message}");
            }
        }
    }

    public void Dispose()
    {
        _process?.Dispose();
    }
}

class Program
{
    static async Task Main(string[] args)
    {
        string? outputFile = null;
        int processId = 0;
        
        // Parse arguments
        for (int i = 0; i < args.Length; i++)
        {
            if (args[i] == "--out" || args[i] == "-o")
            {
                if (i + 1 < args.Length)
                {
                    outputFile = args[i + 1];
                    i++; // Skip next argument as it's the file path
                }
                else
                {
                    System.Console.WriteLine("Error: --out parameter requires a file path.");
                    return;
                }
            }
            else if (int.TryParse(args[i], out int pid))
            {
                processId = pid;
            }
        }
        
        if (args.Length == 0 || processId == 0)
        {
            System.Console.WriteLine("DotNetMetrics - Real-time .NET process monitoring tool");
            System.Console.WriteLine();
            System.Console.WriteLine("Usage: dotnet-metrics <PID> [--out|-o <file>]");
            System.Console.WriteLine("   or: dotnet metrics <PID> [--out|-o <file>]");
            System.Console.WriteLine();
            System.Console.WriteLine("Parameters:");
            System.Console.WriteLine("  <PID>           Process ID to monitor");
            System.Console.WriteLine("  --out, -o       Output file path (optional)");
            System.Console.WriteLine("                  If specified, writes JSON to file instead of console");
            System.Console.WriteLine();
            System.Console.WriteLine("Examples:");
            System.Console.WriteLine("  dotnet-metrics 1234");
            System.Console.WriteLine("  dotnet-metrics 1234 --out metrics.json");
            System.Console.WriteLine("  dotnet-metrics 1234 -o C:\\temp\\process-metrics.json");
            System.Console.WriteLine();
            System.Console.WriteLine("To find process PID:");
            System.Console.WriteLine("  Windows: Get-Process | Where-Object {$_.ProcessName -like '*your-app*'}");
            System.Console.WriteLine("  Linux:   ps aux | grep your-app");
            System.Console.WriteLine("  macOS:   ps aux | grep your-app");
            return;
        }

        ProcessMonitor? monitor = null;
        try
        {
            monitor = new ProcessMonitor(processId);

            var options = new JsonSerializerOptions
            {
                WriteIndented = false,
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            };

            // First measurement for CPU initialization
            // monitor.GetMetrics();
            // await Task.Delay(1000);

            while (true)
            {
                try
                {
                    var metrics = monitor.GetMetrics();
                    var json = JsonSerializer.Serialize(metrics, options);
                    
                    if (!string.IsNullOrEmpty(outputFile))
                    {
                        // Write to file (overwrite each time)
                        await File.WriteAllTextAsync(outputFile, json);
                    }
                    else
                    {
                        System.Console.WriteLine(json);
                    }
                }
                catch (InvalidOperationException ex)
                {
                    if (!string.IsNullOrEmpty(outputFile))
                    {
                        await File.WriteAllTextAsync(outputFile, $"{{\"error\":\"{ex.Message}\"}}");
                    }
                    else
                    {
                        System.Console.WriteLine($"Error: {ex.Message} {ex.InnerException?.Message} {ex.StackTrace}");
                    }
                    break;
                }
                catch (IOException ex)
                {
                    if (string.IsNullOrEmpty(outputFile))
                    {
                        System.Console.WriteLine($"Error writing to file: {ex.Message}");
                    }
                    break;
                }

                await Task.Delay(1000);
            }
        }
        catch (ArgumentException ex)
        {
            if (string.IsNullOrEmpty(outputFile))
            {
                System.Console.WriteLine($"Error: {ex.Message}");
            }
        }
        catch (InvalidOperationException ex)
        {
            if (string.IsNullOrEmpty(outputFile))
            {
                System.Console.WriteLine($"Error: {ex.Message}");
            }
        }
        catch (Exception ex)
        {
            if (string.IsNullOrEmpty(outputFile))
            {
                System.Console.WriteLine($"Some unexpected error: {ex.Message}, {ex.InnerException?.Message} {ex.StackTrace}");
            }
        }
        finally
        {
            monitor?.Dispose();
        }
    }
}
