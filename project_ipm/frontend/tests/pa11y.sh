#!/bin/bash

# List of URLs to test (hardcoded)
URLs=(
    "http://localhost:5173/"
    "http://localhost:5173/students/home"
    "http://localhost:5173/directors/home"
    "http://localhost:5173/notificacoes"
    "http://localhost:5173/directors/pedidos-troca"
    "http://localhost:5173/directors/alocar-listaAlunos"
    "http://localhost:5173/directors/alocar-aluno/1"
    "http://localhost:5173/directors/consultar-turnos"
    "http://localhost:5173/directors/consultar-turnos/1"
    "http://localhost:5173/students/horario"
    "http://localhost:5173/students/requisitar-troca"
    "http://localhost:5173/students/consultar-turnos"
    "http://localhost:5173/students/historico-trocas"
)

# Output file for merged report
output_file="./relatorios/merged-report.html"

# Make sure the output directory exists
mkdir -p "$(dirname "$output_file")"

# Create the individuals directory if it doesn't exist
mkdir -p "./relatorios/individuals"

# Start the HTML structure for the merged report
echo "<!DOCTYPE html>" >"$output_file"
echo "<html lang='en'>" >>"$output_file"
echo "<head>" >>"$output_file"
echo "<meta charset='UTF-8'>" >>"$output_file"
echo "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" >>"$output_file"
echo "<title>Pa11y Accessibility Reports</title>" >>"$output_file"
echo "<style>" >>"$output_file"
echo "body {" >>"$output_file"
echo "    font-family: Arial, sans-serif;" >>"$output_file"
echo "    background-color: #f4f6f8;" >>"$output_file"
echo "    color: #333;" >>"$output_file"
echo "    margin: 0;" >>"$output_file"
echo "    padding: 0;" >>"$output_file"
echo "    display: flex;" >>"$output_file"
echo "    flex-direction: column;" >>"$output_file"
echo "    align-items: center;" >>"$output_file"
echo "}" >>"$output_file"
echo "h1 {" >>"$output_file"
echo "    color: #0069d9;" >>"$output_file"
echo "    text-align: center;" >>"$output_file"
echo "    margin-top: 40px;" >>"$output_file"
echo "    padding: 20px;" >>"$output_file"
echo "    background-color: #e1f5fe;" >>"$output_file"
echo "    border-radius: 8px;" >>"$output_file"
echo "    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);" >>"$output_file"
echo "}" >>"$output_file"
echo "h2 {" >>"$output_file"
echo "    color: #00796b;" >>"$output_file"
echo "    margin-top: 0;" >>"$output_file"
echo "}" >>"$output_file"
echo "p {" >>"$output_file"
echo "    color: #607d8b;" >>"$output_file"
echo "}" >>"$output_file"
echo "div.url-report {" >>"$output_file"
echo "    background-color: #ffffff;" >>"$output_file"
echo "    border-radius: 8px;" >>"$output_file"
echo "    padding: 20px;" >>"$output_file"
echo "    margin-bottom: 20px;" >>"$output_file"
echo "    width: 80%;" >>"$output_file"
echo "    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);" >>"$output_file"
echo "}" >>"$output_file"
echo "pre {" >>"$output_file"
echo "    background-color: #f5f5f5;" >>"$output_file"
echo "    color: #455a64;" >>"$output_file"
echo "    padding: 15px;" >>"$output_file"
echo "    border-radius: 4px;" >>"$output_file"
echo "    white-space: pre-wrap;" >>"$output_file"
echo "    word-wrap: break-word;" >>"$output_file"
echo "    font-size: 14px;" >>"$output_file"
echo "}" >>"$output_file"
echo "div.report-footer {" >>"$output_file"
echo "    color: #607d8b;" >>"$output_file"
echo "    margin-top: 20px;" >>"$output_file"
echo "    text-align: center;" >>"$output_file"
echo "    padding-bottom: 20px;" >>"$output_file"
echo "}" >>"$output_file"
echo "</style>" >>"$output_file"
echo "</head>" >>"$output_file"
echo "<body>" >>"$output_file"
echo "<h1>Pa11y Accessibility Reports</h1>" >>"$output_file"
echo "<p>Generated on $(date)</p>" >>"$output_file"

# Loop through each URL and run Pa11y, then append the result to the merged report
for url in "${URLs[@]}"; do
    # Improved message with more information and a friendly tone
    echo "🚀 Starting accessibility test for the page: $url"

    # Run Pa11y for the URL and generate the report in HTML format
    report=$(npx pa11y "$url" --reporter html)

    # Get a sanitized version of the URL to use as part of the file name
    sanitized_url=$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g')

    # Create individual report file in the 'individuals' directory
    individual_report="./relatorios/individuals/${sanitized_url}-report.html"
    
    # Start the individual report
    echo "<!DOCTYPE html>" > "$individual_report"
    echo "<html lang='en'>" >> "$individual_report"
    echo "<head>" >> "$individual_report"
    echo "<meta charset='UTF-8'>" >> "$individual_report"
    echo "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" >> "$individual_report"
    echo "<title>Pa11y Accessibility Report for $url</title>" >> "$individual_report"
    echo "</head>" >> "$individual_report"
    echo "<body>" >> "$individual_report"
    echo "<h1>Accessibility Report for $url</h1>" >> "$individual_report"
    echo "<p>Generated on $(date)</p>" >> "$individual_report"
    
    # Include the Pa11y report for this URL in the individual report
    echo "<pre>$report</pre>" >> "$individual_report"

    # Close the individual report
    echo "</body>" >> "$individual_report"
    echo "</html>" >> "$individual_report"

    # Append the URL and report to the merged report file
    echo "<div class='url-report'>" >> "$output_file"
    echo "<h2>Accessibility Report for <span style='color: #1E88E5;'>$url</span></h2>" >> "$output_file"
    echo "<pre>$report</pre>" >> "$output_file"
    echo "</div>" >> "$output_file"
done

# End the HTML structure with footer for merged report
echo "<div class='report-footer'>" >> "$output_file"
echo "<p>End of report.</p>" >> "$output_file"
echo "</div>" >> "$output_file"
echo "</body>" >> "$output_file"
echo "</html>" >> "$output_file"

# Print a message indicating the report is complete
echo "🎉 Merged report has been generated: $output_file"
echo "📄 Individual reports are saved in the relatorios/individuals/ directory."

# Open the HTML report in the default browser (this works on Linux, macOS, and Windows)
if which xdg-open >/dev/null 2>&1; then
    # Linux
    xdg-open "$output_file"
elif which open >/dev/null 2>&1; then
    # macOS
    open "$output_file"
elif which start >/dev/null 2>&1; then
    # Windows
    start "$output_file"
else
    echo "Unable to open the report automatically. Please open it manually from: $output_file"
fi
echo "✅ All tests completed successfully!"