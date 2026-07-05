import json, base64, urllib.request, os, sys

GEMINI_API_KEY=os.environ["GEMINI_API_KEY"]
MODEL="gemini-3-pro-image-preview"
URL=f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent?key={GEMINI_API_KEY}"

STYLE = """STYLE (follow exactly):
- Flat 2D vector infographic on a PURE WHITE background. No 3D, no gradients, no drop shadows, no photorealism.
- Every box is a rounded rectangle with a THICK solid BLACK outline (~4px) and ~12px rounded corners, filled with ONE flat solid color.
- Consistent color-coding, each concept keeps ONE color everywhere:
  * vivid purple (#A64BF0) = a Worker / an active compute element
  * light lavender (#E4CCF7) = inactive / secondary copies
  * magenta-pink (#E0218A) = GCS / global control / special markers
  * cream-beige (#EFE4D5) with brown text (#7A4A2E) = Raylet / Scheduler module
  * teal (#57C7C7) = Object Store; a DASHED teal border groups a Node
  * olive-gold (#A8912E) = the Driver
- Labels are BOLD rounded sans-serif; keep ALL labels short ENGLISH technical terms (Worker, Scheduler, Object Store, GCS, Driver, Node, Task, Object X, Object Y, Ownership Table).
- Thin curved BLACK arrows for data/control flow; small numbered gray circle badges (1,2,3...) mark step order; one short dark-red (#8B1A1A) caption annotates the key point.
- Generous whitespace, clean layout, minimalist.
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
            open(f"images/{name}.png","wb").write(img)
            print(f"{name}: saved ({len(img):,} bytes)"); return
    print(f"{name}: NO IMAGE")

if __name__=="__main__":
    import importlib.util
    spec=json.load(open(sys.argv[1]))
    for name,content in spec.items():
        gen(name, content)
