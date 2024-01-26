#!/bin/bash

# Define boundary for MIME parts
boundary="=====$(date +%Y%m%d%H%M%S)====="

script_dir=$(dirname "$0")
script_dir=$(realpath "$script_dir")
public_hostname=$(curl -sX GET http://169.254.169.254/latest/meta-data/public-hostname)

recipient="anas_aboungab@hotmail.co.uk"
sender="tokyo.wsl@gmail.com"
subject="Financial Times news from $public_hostname PC"

# Start creating the MIME formatted email
email_file="$script_dir/email_file"
echo "To: $recipient" > "$email_file"
echo "From: $sender" >> "$email_file"
echo "Subject: $subject" >> "$email_file"
echo "MIME-Version: 1.0" >> "$email_file"
echo "Content-Type: multipart/mixed; boundary=\"$boundary\"" >> "$email_file"
echo "" >> "$email_file"
echo "--$boundary" >> "$email_file"
echo "Content-Type: text/html; charset=\"utf-8\"" >> "$email_file"
echo "" >> "$email_file"

# Email body with HTML content
echo "<html><body>" >> "$email_file"
echo "<p>Please find below the Financial Times news links:</p><ul>" >> "$email_file"

# Generate list items with clickable links
cd "$script_dir"
find ft-news-results -type f -name "*.txt" | while IFS= read -r file; do
    prev_line="" # Variable to hold the title of the article
    section_name="$(echo $file | sort -u | cut -d'/' -f2)"
    echo -e "\n<h3>${section_name%.*}</h3>" >> "$email_file"
    while IFS= read -r line; do
        if [[ $line == *"Link:"* ]]; then
            link=$(echo "$line" | sed 's/Link:\s*//')
            # Use the previous line as the article title
            title="$prev_line"
            echo "<li><strong>$title</strong> - <a href=\"$link\">$link</a></li>" >> "$email_file"
        else
            # Store the current line as the previous line for the next iteration
            prev_line="$line"
        fi
    done < "$file"
done

echo "</ul></body></html>" >> "$email_file"

# Final boundary with double dashes to indicate end of the message
echo "--$boundary--" >> "$email_file"

# Send the email
msmtp -a default "$recipient" < "$email_file"
echo "Sent an email to $recipient with clickable links."