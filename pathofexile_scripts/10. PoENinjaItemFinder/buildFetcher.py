import requests
import json


def fetch_json_from_url(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from {url}: {e}")
        return None


file_path = 'links.txt'
json_responses = []

with open(file_path, 'r', encoding="utf8") as file:
    for line in file:
        url = line.strip()
        if url:
            print(f"Fetching data from {url}...")
            json_response = fetch_json_from_url(url)
            if json_response:
                json_responses.append(json_response)

output_file = 'builds.json'

with open(output_file, 'w', encoding="utf8") as outfile:
    json.dump(json_responses, outfile, indent=4)

print(f"Fetched {len(json_responses)} JSON responses.")
