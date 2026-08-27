import json, sys
path = r"c:\Users\Mario\OneDrive\Desktop\Codename-Hydrengea\mods\codenamehydrengea\songs\flashfire\charts\hellsider-e.json"
with open(path, encoding='utf-8') as f:
    data = json.load(f)
count = sum(1 for e in data.get('events', []) if e.get('name') == 'Dodge Warning')
print('Total Dodge Warning events:', count)
