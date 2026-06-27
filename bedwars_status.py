import sys
import json
import urllib.request
import urllib.error

# No API key needed — Slothpixel is a free Hypixel API proxy
SLOTHPIXEL_URL = "https://api.slothpixel.me/api/players/{}"

BEDWARS_GAME_TYPES = {"BEDWARS"}
LOBBY_GAME_TYPES = {"LOBBY", "LIMBO"}


def fetch_json(url):
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "bedwars-checker/1.0"})
        with urllib.request.urlopen(req, timeout=8) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        if e.code == 429:
            print("Rate limited. Try again in a moment.")
        elif e.code == 404:
            print("Player not found.")
        else:
            print(f"HTTP error {e.code}")
        return None
    except Exception as e:
        print(f"Request failed: {e}")
        return None


def check_status(username):
    data = fetch_json(SLOTHPIXEL_URL.format(username))
    if not data:
        return

    if data.get("error"):
        print(f"Error: {data['error']}")
        return

    online = data.get("online", False)

    if not online:
        print(f"{username} is offline.")
        return

    game_type = (data.get("game_type") or "").upper()
    game_mode = data.get("game_mode") or ""
    game_map = data.get("game_map") or ""

    if game_type in BEDWARS_GAME_TYPES:
        parts = [f"{username} is in BedWars"]
        if game_mode:
            parts.append(f"mode: {game_mode}")
        if game_map:
            parts.append(f"map: {game_map}")
        print(" | ".join(parts))
    elif game_type in LOBBY_GAME_TYPES or game_type == "":
        print(f"{username} is in the lobby.")
    else:
        print(f"{username} is online playing {game_type}" + (f" ({game_mode})" if game_mode else ""))


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python bedwars_status.py <username>")
        sys.exit(1)

    check_status(sys.argv[1])
