import json
import os

# Path to the hellsider-e chart JSON file
chart_path = r"c:\Users\Mario\OneDrive\Desktop\Codename-Hydrengea\mods\codenamehydrengea\songs\flashfire\charts\hellsider-e.json"

# Load the JSON data
with open(chart_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Modify all Dodge Warning events to have a pressure penalty of 0.08 (5th param)
count = 0
for event in data.get('events', []):
    if event.get('name') == 'Dodge Warning' and isinstance(event.get('params'), list):
        # Ensure the params list has at least 5 items
        if len(event['params']) >= 5:
            old = event['params'][4]
            event['params'][4] = 0.08
            count += 1
        else:
            # Pad the params list if it's shorter than expected
            while len(event['params']) < 5:
                event['params'].append(0)
            event['params'][4] = 0.08
            count += 1

# Write the modified JSON back to the file (pretty-printed)
with open(chart_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"Updated {count} Dodge Warning events with pressure penalty 0.08.")
