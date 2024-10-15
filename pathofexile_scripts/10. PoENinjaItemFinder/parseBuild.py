import json

file_path = 'builds.json'


with open(file_path, 'r', encoding="utf8") as file:
    data = json.load(file)

json_items = []


def addItem(build, item):
    characterName = build["name"]
    accountLevel = build["level"]
    itemName = item["name"]
    implicitMods = item["implicitMods"]
    explicitMods = item["explicitMods"]
    fracturedMods = item["fracturedMods"]
    craftedMods = item["craftedMods"]
    enchantMods = item["enchantMods"]
    properties = item["properties"]
    additionalProperties = item["additionalProperties"]
    sockets = item["sockets"]
    socketedItems = item["socketedItems"]

    mods = explicitMods + fracturedMods + craftedMods

    print(mods)

    itemData = {
        "character": characterName,
        "level": accountLevel,
        "name": itemName,
        "implicitMods": implicitMods,
        "mods": mods,
        "enchantMods": enchantMods,
        "properties": properties,
        "additionalProperties": additionalProperties,
        "sockets": sockets,
        "socketedItems": socketedItems,
    }

    json_items.append(itemData)

    # print(itemData)


itemTypes = ['items', 'flasks', 'jewels']
input_item_name = input(
    "Item name you wanna look for (empty for base type): ").strip()

for build in data:
    for itemType in itemTypes:
        # print("\n\n")
        for item in build[itemType]:
            item = item['itemData']
            item_name = item['name']
            if input_item_name in item_name.strip():
                addItem(build, item)

output_file = 'items.json'

with open(output_file, 'w', encoding="utf8") as outfile:
    json.dump(json_items, outfile, indent=4)
