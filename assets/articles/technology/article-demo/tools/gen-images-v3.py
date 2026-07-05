import json, base64, urllib.request, os, sys

# v3 image generator — "技术蓝墨" palette (see ../image-style.md §4).
# Same usage as gen-images.py: python3 gen-images-v3.py <prompts.json>
# Writes PNGs into ./images/ of the CWD.

GEMINI_API_KEY=os.environ["GEMINI_API_KEY"]
MODEL="gemini-3-pro-image-preview"
URL=f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent?key={GEMINI_API_KEY}"

STYLE = """STYLE (follow exactly):
- Flat 2D vector infographic on a PURE WHITE background. No 3D, no gradients, no drop shadows, no photorealism.
- Every box is a rounded rectangle with a CLEAN MEDIUM-THIN solid outline in ink-black (#1B2430, ~2px — crisp but NOT heavy/chunky) and ~12px rounded corners, filled with ONE flat solid color.
- RESTRAINED, calm engineering palette. Low saturation. Consistent color-coding, each concept keeps ONE color everywhere:
  * steel blue (#2F6FB0) = a Worker / an active compute element (the ONLY strong color)
  * pale blue-grey (#D3E0EC) = inactive / secondary / cached copies
  * cool-grey box (#EBEEF2) with dark ink text (#33414F) = Raylet / Scheduler / a module
  * muted teal (#3F8F8A) = Object Store / final output
  * sage green (#5A8F6B) = the Driver / a second variable
  * ochre-red (#B0553F) = THE ONLY WARM ACCENT, used sparingly — special markers (PIN, GCS) AND the single annotation caption share this one color
- Grouping containers (a Node) use ONLY a dashed muted-teal (#3F8F8A) border — do NOT wrap them in a solid black outer box.
- Labels are BOLD rounded sans-serif; keep ALL labels short ENGLISH technical terms (Worker, Scheduler, Object Store, GCS, Driver, Node, Task, Object X, Object Y, Ownership Table, Object Table).
- Thin curved ink-black (#1B2430) arrows for data/control flow; small numbered cool-grey (#9AA6B2) circle badges (1,2,3...) mark step order; exactly ONE short ochre-red (#B0553F) caption annotates the key point.
- Generous whitespace, clean layout, minimalist and QUIET — nothing should visually shout except the single ochre-red annotation.
Flat vector infographic, no watermark, no signature."""

def gen(name, content):
    prompt = content + "\n\n" + STYLE
    payload=json.dumps({"contents":[{"parts":[{"text":prompt}]}],
        "generationConfig":{"responseModalities":["TEXT","IMAGE"],"temperature":0.6}}).encode()
    req=urllib.request.Request(URL,data=payload,headers={"Content-Type":"application/json","User-Agent":"ImageGen/1.0"})
    try:
        resp=urllib.request.urlopen(req,timeout=180); result=json.loads(resp.read())
    except urllib.error.HTTPError as e:
        print(f"{name}: HTTP {e.code} {e.read().decode()[:200]}"); return
    for part in result["candidates"][0]["content"]["parts"]:
        if "inlineData" in part:
            img=base64.b64decode(part["inlineData"]["data"])
            os.makedirs("images", exist_ok=True)
            open(f"images/{name}.png","wb").write(img)
            print(f"{name}: saved ({len(img):,} bytes)"); return
    print(f"{name}: NO IMAGE")

if __name__=="__main__":
    spec=json.load(open(sys.argv[1]))
    for name,content in spec.items():
        gen(name, content)
