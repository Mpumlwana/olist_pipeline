# Run the whole pipeline: every SQL file in the sql folder, in number order.
# Stops at the first error, so we never build clean tables from broken data.

$files = Get-ChildItem -Path sql -Filter *.sql | Sort-Object Name
foreach ($file in $files) {
    Write-Host ("Running " + $file.Name + "...") -ForegroundColor Cyan
    Get-Content $file.FullName | docker exec -i olist_postgres psql -U olist_user -d olist -v ON_ERROR_STOP=1
    if ($LASTEXITCODE -ne 0) {
        Write-Host ("FAILED: " + $file.Name + ". Pipeline stopped.") -ForegroundColor Red
        exit 1
    }
}
Write-Host "Pipeline finished. Check the stamps of 08_data_checks.sql above." -ForegroundColor Green
