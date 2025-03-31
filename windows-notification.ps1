Param ([switch]$Empty, [switch]$Silent)

function Conv2SJIS($UTF8String) {
    $ByteData = [System.Text.Encoding]::UTF8.GetBytes($UTF8String)
    $SJISString = [System.Text.Encoding]::Default.GetString($ByteData)
    return $SJISString
}

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$app_id = "{6D809377-6AF0-444B-8957-A3773F02200E}\obs-studio\bin\64bit\obs64.exe"
$title = "リプレイ削除"
$message = ""
if ($Empty) {
    $message = "リプレイがありません"
} else {
    $message = "リプレイを削除しました"
}
$audio = ""
if ($Silent) {
    $audio = '<audio silent="true"/>'
}

$content = @"
<?xml version="1.0" encoding="utf-8"?>
<toast duration="short">
<visual>
    <binding template="ToastGeneric">
        <text>$($title)</text>
        <text>$($message)</text>
    </binding>
</visual>
$($audio)
</toast>
"@
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($content)
$toast = New-Object Windows.UI.Notifications.ToastNotification $xml
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app_id).Show($toast)
