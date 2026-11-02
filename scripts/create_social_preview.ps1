$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$destination = Join-Path $repoRoot 'social-preview.png'
$bitmap = [System.Drawing.Bitmap]::new(1280, 640)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

function New-RoundedPath([float]$X, [float]$Y, [float]$Width, [float]$Height, [float]$Radius) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $diameter = $Radius * 2
    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc($X + $Width - $diameter, $Y, $diameter, $diameter, 270, 90)
    $path.AddArc($X + $Width - $diameter, $Y + $Height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($X, $Y + $Height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-RoundedRect($Graphics, [float]$X, [float]$Y, [float]$Width, [float]$Height, [float]$Radius, $Brush) {
    $path = New-RoundedPath $X $Y $Width $Height $Radius
    $Graphics.FillPath($Brush, $path)
    $path.Dispose()
}

function Draw-Label($Graphics, [string]$Text, [float]$X, [float]$Y, [float]$Size, $Color, [bool]$Bold = $false) {
    $style = if ($Bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
    $font = [System.Drawing.Font]::new('Segoe UI', $Size, $style, [System.Drawing.GraphicsUnit]::Pixel)
    $brush = [System.Drawing.SolidBrush]::new($Color)
    $Graphics.DrawString($Text, $font, $brush, $X, $Y)
    $font.Dispose()
    $brush.Dispose()
}

try {
    $background = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
        [System.Drawing.Rectangle]::new(0, 0, 1280, 640),
        [System.Drawing.ColorTranslator]::FromHtml('#0A1020'),
        [System.Drawing.ColorTranslator]::FromHtml('#182747'),
        0
    )
    $graphics.FillRectangle($background, 0, 0, 1280, 640)
    $background.Dispose()

    $glow = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(34, 77, 211, 196))
    $graphics.FillEllipse($glow, 730, -145, 500, 500)
    $glow.Dispose()

    $white = [System.Drawing.ColorTranslator]::FromHtml('#F7FAFF')
    $muted = [System.Drawing.ColorTranslator]::FromHtml('#B4C0D7')
    $teal = [System.Drawing.ColorTranslator]::FromHtml('#62E2D0')
    $dim = [System.Drawing.ColorTranslator]::FromHtml('#8292AF')
    $panel = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(238, 17, 28, 49))
    $inner = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 24, 38, 63))
    $softBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(100, 130, 158, 191), 1)
    $graphics.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(10, 255, 255, 255)), 0, 0, 1280, 640)

    $iconBrush = [System.Drawing.SolidBrush]::new($teal)
    $graphics.FillEllipse($iconBrush, 94, 82, 17, 17)
    $iconBrush.Dispose()
    Draw-Label $graphics 'AGENT SKILL' 121 79 16 $teal $true
    Draw-Label $graphics 'Humanizer' 92 132 69 $white $true
    Draw-Label $graphics 'for agents' 97 211 38 $teal $true
    Draw-Label $graphics 'Make AI-sounding prose feel natural.' 99 283 23 $white
    Draw-Label $graphics 'Keep meaning and voice intact.' 99 319 21 $muted

    $pillBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(85, 98, 123, 158))
    $pillBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(85, 156, 179, 206), 1)
    $pills = @(
        @{ Text = 'Agent Skills'; X = 98; Width = 137 },
        @{ Text = 'Claude Code'; X = 246; Width = 142 },
        @{ Text = 'Cursor'; X = 399; Width = 91 },
        @{ Text = 'ChatGPT ZIP'; X = 501; Width = 135 }
    )
    foreach ($pill in $pills) {
        $path = New-RoundedPath $pill.X 382 $pill.Width 38 19
        $graphics.FillPath($pillBrush, $path)
        $graphics.DrawPath($pillBorder, $path)
        $path.Dispose()
        Draw-Label $graphics $pill.Text ($pill.X + 13) 391 15 $white $true
    }

    $cardPath = New-RoundedPath 700 92 490 454 24
    $graphics.FillPath($panel, $cardPath)
    $graphics.DrawPath($softBorder, $cardPath)
    $cardPath.Dispose()
    Draw-Label $graphics 'A QUICK REWRITE' 735 121 15 $teal $true
    Draw-Label $graphics 'Same idea, more natural wording' 735 146 20 $white $true

    Draw-RoundedRect $graphics 728 191 434 121 15 $inner
    Draw-Label $graphics 'BEFORE' 749 207 13 $dim $true
    Draw-Label $graphics 'I am writing to inform you that the' 749 235 19 $muted
    Draw-Label $graphics 'update has been completed.' 749 263 19 $muted

    Draw-RoundedRect $graphics 728 330 434 145 15 $inner
    Draw-Label $graphics 'AFTER' 749 347 13 $teal $true
    Draw-Label $graphics 'The update is finished.' 749 376 22 $white $true
    Draw-Label $graphics 'Clearer phrasing, same meaning.' 749 412 17 $muted
    Draw-Label $graphics 'Meaning preserved · voice-first edits' 735 500 15 $muted

    Draw-Label $graphics 'Independent community package · MIT-licensed original by Siqi Chen' 99 555 14 $muted
    Draw-Label $graphics 'github.com/gamechanged129/humanizer-plugin' 99 583 15 $dim

    $bitmap.Save($destination, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Output "Created $destination"
}
finally {
    $graphics.Dispose()
    $bitmap.Dispose()
    $panel.Dispose()
    $inner.Dispose()
    $softBorder.Dispose()
    $pillBrush.Dispose()
    $pillBorder.Dispose()
}
