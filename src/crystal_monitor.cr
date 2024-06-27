# Function to get CPU usage
def get_cpu_usage : String
  File.read("/proc/stat").split("\n").first.split[1..-1].join(" ")
end

# Function to get Memory usage
def get_memory_usage : String
  meminfo = File.read("/proc/meminfo")
  total = meminfo.match(/MemTotal:\s+(\d+)/).try &.[1].try &.to_i || 0
  free = meminfo.match(/MemFree:\s+(\d+)/).try &.[1].try &.to_i || 0
  available = meminfo.match(/MemAvailable:\s+(\d+)/).try &.[1].try &.to_i || 0
  used = total - free
  "Total: #{total} kB, Used: #{used} kB, Available: #{available} kB"
end

# Function to get Disk usage
def get_disk_usage : String
  `df -h / | tail -1`.strip
end

# Function to get Uptime
def get_uptime : String
  uptime_seconds = File.read("/proc/uptime").split.first.to_f
  hours = (uptime_seconds / 3600).floor
  minutes = ((uptime_seconds % 3600) / 60).floor
  seconds = (uptime_seconds % 60).floor
  "#{hours}h #{minutes}m #{seconds}s"
end

# Function to get Load Average
def get_load_average : String
  File.read("/proc/loadavg").split[0..2].join(" ")
end

# Function to get Kernel Version
def get_kernel_version : String
  `uname -r`.strip
end

# Function to get Hostname
def get_hostname : String
  `hostname`.strip
end

# Function to get Number of Processes
def get_number_of_processes : String
  processes_match = File.read("/proc/stat").scan(/processes (\d+)/)[0][0]
end

# Function to get Swap Usage
def get_swap_usage : String
  meminfo = File.read("/proc/meminfo")
  total = meminfo.match(/SwapTotal:\s+(\d+)/).try &.[1].try &.to_i || 0
  free = meminfo.match(/SwapFree:\s+(\d+)/).try &.[1].try &.to_i || 0
  used = total - free
  "Total: #{total} kB, Used: #{used} kB, Free: #{free} kB"
end

# Function to get Open Files Count
def get_open_files_count : String
  `lsof | wc -l`.strip
end

# Function to get Users Currently Logged In
def get_users_logged_in : String
  `who | wc -l`.strip
end

# Function to get Network Interfaces
def get_network_interfaces : String
  interfaces = `ls /sys/class/net`.split("\n").join(", ")
  interfaces.empty? ? "No network interfaces found" : interfaces
end

# Main function to gather all information
def gather_system_info : Hash(String, String)
  {
    "CPU Usage" => get_cpu_usage,
    "Memory Usage" => get_memory_usage,
    "Disk Usage" => get_disk_usage,
    "Uptime" => get_uptime,
    "Load Average" => get_load_average,
    "Kernel Version" => get_kernel_version,
    "Hostname" => get_hostname,
    "Number of Processes" => get_number_of_processes,
    "Swap Usage" => get_swap_usage,
    "Open Files Count" => get_open_files_count,
    "Users Logged In" => get_users_logged_in,
    "Network Interfaces" => get_network_interfaces
  }
end

# Display the information
def display_system_info
  info = gather_system_info
  puts "System Information"
  puts "------------------"
  info.each do |key, value|
    puts "#{key}: #{value}"
  end
end

# Run the display function
display_system_info

