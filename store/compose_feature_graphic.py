"""Compose a polished Google Play feature graphic (1024x500)."""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont, ImageEnhance

STORE = Path(r"C:\Users\karox\Desktop\eSIM KRD\esimkrd\store")
LOGO = STORE / "assets" / "logo.png"
SHOT = STORE / "assets" / "screenshot.png"
OUT = STORE / "esim-krd-feature-graphic-1024x500.png"

W, H = 1024, 500


def load_font(size: int, bold: bool = True) -> ImageFont.ImageFont:
    candidates = [
        r"C:\Windows\Fonts\segoeuib.ttf" if bold else r"C:\Windows\Fonts\segoeui.ttf",
        r"C:\Windows\Fonts\arialbd.ttf" if bold else r"C:\Windows\Fonts\arial.ttf",
        r"C:\Windows\Fonts\calibrib.ttf" if bold else r"C:\Windows\Fonts\calibri.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def lerp(a: float, b: float, t: float) -> float:
    return a + (b - a) * t


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, size[0] - 1, size[1] - 1), radius=radius, fill=255)
    return mask


def make_background() -> Image.Image:
    """Warm orange gradient with soft light bloom and elegant arcs."""
    img = Image.new("RGB", (W, H))
    px = img.load()
    # Diagonal gradient: light top-left → deep bottom-right
    c1 = (255, 130, 72)   # light
    c2 = (255, 99, 38)    # mid
    c3 = (214, 70, 18)    # deep

    for y in range(H):
        for x in range(W):
            t = (x * 0.45 + y * 1.1) / (W * 0.45 + H * 1.1)
            if t < 0.55:
                u = t / 0.55
                r = int(lerp(c1[0], c2[0], u))
                g = int(lerp(c1[1], c2[1], u))
                b = int(lerp(c1[2], c2[2], u))
            else:
                u = (t - 0.55) / 0.45
                r = int(lerp(c2[0], c3[0], u))
                g = int(lerp(c2[1], c3[1], u))
                b = int(lerp(c2[2], c3[2], u))
            px[x, y] = (r, g, b)

    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer, "RGBA")

    # Soft top-left light
    light = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ld = ImageDraw.Draw(light)
    for i in range(18, 0, -1):
        alpha = int(10 + i * 1.2)
        r = 80 + i * 22
        ld.ellipse((-120, -160, r, r - 40), fill=(255, 220, 180, alpha))
    light = light.filter(ImageFilter.GaussianBlur(28))
    layer = Image.alpha_composite(layer, light)

    # Elegant signal arcs on the left
    for i, rad in enumerate((160, 220, 280, 340)):
        alpha = 22 - i * 4
        bbox = (-40 - i * 10, 40 - i * 8, rad, rad + 80)
        draw.arc(bbox, start=300, end=60, fill=(255, 255, 255, alpha), width=2)

    # Soft flowing ribbons behind phone
    for i, (amp, phase, alpha) in enumerate(((42, 0.0, 26), (28, 1.2, 18), (55, 2.1, 12))):
        pts = []
        y0 = 120 + i * 70
        for x in range(-20, W + 40, 12):
            y = y0 + math.sin((x / 95.0) + phase) * amp + (x * 0.04)
            pts.append((x, y))
        # ribbon thickness via parallel polyline approx
        for thick in range(-6, 7):
            shifted = [(x, y + thick) for x, y in pts]
            draw.line(shifted, fill=(255, 255, 255, max(4, alpha - abs(thick) * 2)), width=1)

    base = img.convert("RGBA")
    return Image.alpha_composite(base, layer)


def make_logo_badge(logo: Image.Image, size: int = 104) -> Image.Image:
    """Logo with soft shadow and thin white ring."""
    badge = Image.new("RGBA", (size + 28, size + 28), (0, 0, 0, 0))

    # Shadow
    shadow = Image.new("RGBA", badge.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle((12, 14, size + 12, size + 14), radius=24, fill=(0, 0, 0, 55))
    shadow = shadow.filter(ImageFilter.GaussianBlur(10))
    badge = Image.alpha_composite(badge, shadow)

    # White ring plate
    plate = Image.new("RGBA", badge.size, (0, 0, 0, 0))
    pd = ImageDraw.Draw(plate)
    pd.rounded_rectangle((6, 6, size + 10, size + 10), radius=24, fill=(255, 255, 255, 235))
    badge = Image.alpha_composite(badge, plate)

    # Logo
    logo_r = logo.convert("RGBA").resize((size, size), Image.Resampling.LANCZOS)
    mask = rounded_mask((size, size), 20)
    logo_out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    logo_out.paste(logo_r, (0, 0), logo_r)
    final_logo = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    final_logo.paste(logo_out, (0, 0), mask)
    badge.paste(final_logo, (8, 8), final_logo)
    return badge


def android_phone(screenshot: Image.Image) -> Image.Image:
    """Polished Android frame (punch-hole), not iPhone."""
    # Target visual height ~445 inside canvas
    screen_h = 410
    screen_w = int(screen_h * screenshot.width / screenshot.height)
    screen_w = max(190, min(screen_w, 220))
    screen_h = int(screen_w * screenshot.height / screenshot.width)

    bezel = 9
    top_bar = 16
    bottom_bar = 14
    radius = 34
    phone_w = screen_w + bezel * 2
    phone_h = screen_h + top_bar + bottom_bar

    canvas = Image.new("RGBA", (phone_w + 40, phone_h + 40), (0, 0, 0, 0))

    # Layered soft shadow
    for blur, offset, alpha in ((18, 14, 50), (10, 8, 40)):
        sh = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
        sd = ImageDraw.Draw(sh)
        sd.rounded_rectangle(
            (18, 12 + offset, 18 + phone_w, 12 + offset + phone_h),
            radius=radius + 2,
            fill=(0, 0, 0, alpha),
        )
        canvas = Image.alpha_composite(canvas, sh.filter(ImageFilter.GaussianBlur(blur)))

    ox, oy = 14, 8
    draw = ImageDraw.Draw(canvas)

    # Outer metal rim
    draw.rounded_rectangle(
        (ox - 1, oy - 1, ox + phone_w, oy + phone_h),
        radius=radius + 1,
        fill=(72, 72, 76),
    )
    # Body
    draw.rounded_rectangle(
        (ox, oy, ox + phone_w - 1, oy + phone_h - 1),
        radius=radius,
        fill=(22, 22, 24),
    )
    # Subtle inner highlight
    draw.rounded_rectangle(
        (ox + 2, oy + 2, ox + phone_w - 3, oy + phone_h - 3),
        radius=radius - 2,
        outline=(70, 70, 74),
        width=1,
    )

    # Screen bed
    sx, sy = ox + bezel, oy + top_bar
    draw.rounded_rectangle(
        (sx - 1, sy - 1, sx + screen_w, sy + screen_h),
        radius=16,
        fill=(0, 0, 0),
    )

    shot = screenshot.convert("RGBA").resize((screen_w, screen_h), Image.Resampling.LANCZOS)
    # Slight clarity boost
    shot = ImageEnhance.Contrast(shot).enhance(1.05)
    shot = ImageEnhance.Sharpness(shot).enhance(1.08)
    canvas.paste(shot, (sx, sy), rounded_mask((screen_w, screen_h), 14))

    # Punch-hole camera
    cx = ox + phone_w // 2
    cy = oy + top_bar // 2 + 1
    draw.ellipse((cx - 6, cy - 6, cx + 6, cy + 6), fill=(8, 8, 10))
    draw.ellipse((cx - 3, cy - 3, cx + 3, cy + 3), fill=(35, 55, 90))
    draw.ellipse((cx - 1, cy - 1, cx + 1, cy + 1), fill=(120, 160, 210))

    # Side keys
    draw.rounded_rectangle((ox + phone_w - 1, oy + 95, ox + phone_w + 4, oy + 145), radius=2, fill=(90, 90, 94))
    draw.rounded_rectangle((ox - 4, oy + 85, ox + 1, oy + 115), radius=2, fill=(90, 90, 94))
    draw.rounded_rectangle((ox - 4, oy + 125, ox + 1, oy + 175), radius=2, fill=(90, 90, 94))

    # Gesture pill
    pill_w, pill_h = 52, 4
    px = ox + (phone_w - pill_w) // 2
    py = oy + phone_h - bottom_bar + 5
    draw.rounded_rectangle((px, py, px + pill_w, py + pill_h), radius=2, fill=(210, 210, 214))

    # Soft gloss on top edge of phone
    gloss = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    gd = ImageDraw.Draw(gloss)
    gd.rounded_rectangle((ox + 8, oy + 4, ox + phone_w - 8, oy + 28), radius=12, fill=(255, 255, 255, 18))
    gloss = gloss.filter(ImageFilter.GaussianBlur(4))
    canvas = Image.alpha_composite(canvas, gloss)

    return canvas


def draw_text_block(canvas: Image.Image, x: int, y: int) -> None:
    draw = ImageDraw.Draw(canvas)
    title = load_font(66, bold=True)
    sub = load_font(25, bold=False)
    tiny = load_font(17, bold=False)

    for dx, dy, a in ((0, 3, 45), (0, 1, 30)):
        draw.text((x + dx, y + dy), "eSIM KRD", font=title, fill=(0, 0, 0, a))

    draw.text((x, y), "eSIM KRD", font=title, fill=(255, 255, 255, 255))

    title_bbox = draw.textbbox((x, y), "eSIM KRD", font=title)
    title_w = title_bbox[2] - title_bbox[0]

    # Accent bar under full brand name
    bar_y = y + 76
    bar_w = title_w
    draw.rounded_rectangle((x, bar_y, x + bar_w, bar_y + 4), radius=2, fill=(255, 255, 255, 200))

    draw.text((x, bar_y + 18), "Travel eSIM  ·  Instant data", font=sub, fill=(255, 255, 255, 235))

    chip_y = bar_y + 64
    chips = ["200+ countries", "FIB & Card", "Instant install"]
    cx = x
    for label in chips:
        bbox = draw.textbbox((0, 0), label, font=tiny)
        tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
        pad_x, pad_y = 14, 8
        w, h = tw + pad_x * 2, th + pad_y * 2
        chip = Image.new("RGBA", (w + 8, h + 8), (0, 0, 0, 0))
        # soft chip shadow
        cd = ImageDraw.Draw(chip)
        cd.rounded_rectangle((3, 4, w + 3, h + 4), radius=16, fill=(0, 0, 0, 35))
        chip = chip.filter(ImageFilter.GaussianBlur(2))
        cd = ImageDraw.Draw(chip)
        cd.rounded_rectangle((0, 0, w - 1, h - 1), radius=15, fill=(255, 255, 255, 48), outline=(255, 255, 255, 90))
        canvas.alpha_composite(chip, (cx, chip_y))
        ImageDraw.Draw(canvas).text(
            (cx + pad_x, chip_y + pad_y - 1),
            label,
            font=tiny,
            fill=(255, 255, 255, 250),
        )
        cx += w + 12


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)

    canvas = make_background()
    logo = Image.open(LOGO)
    shot = Image.open(SHOT)

    badge = make_logo_badge(logo, size=96)
    phone = android_phone(shot)

    target_phone_h = 468
    if phone.height != target_phone_h:
        scale = target_phone_h / phone.height
        phone = phone.resize((int(phone.width * scale), int(phone.height * scale)), Image.Resampling.LANCZOS)

    # Optical balance: brand block vertically centered with phone body
    left_margin = 52
    content_h = 210
    brand_top = (H - content_h) // 2 - 8
    canvas.alpha_composite(badge, (left_margin, brand_top))

    text_x = left_margin + badge.width + 6
    text_y = brand_top + 14
    draw_text_block(canvas, text_x, text_y)

    px = W - phone.width + 10
    py = (H - phone.height) // 2

    # Soft glow behind phone for depth
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gx = px + phone.width // 2
    gy = py + phone.height // 2
    gd.ellipse((gx - 160, gy - 210, gx + 160, gy + 210), fill=(255, 210, 160, 55))
    glow = glow.filter(ImageFilter.GaussianBlur(36))
    canvas = Image.alpha_composite(canvas, glow)

    # Phone sits in right third with slight inward crop for depth
    canvas.alpha_composite(phone, (px, py))

    # Soft edge vignette
    vig = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    vd = ImageDraw.Draw(vig)
    vd.rectangle((0, 0, W, H), outline=(0, 0, 0, 28), width=22)
    vig = vig.filter(ImageFilter.GaussianBlur(12))
    canvas = Image.alpha_composite(canvas, vig)

    result = canvas.convert("RGB")
    result.save(OUT, "PNG", optimize=True)
    print(f"saved {OUT} size={result.size} bytes={OUT.stat().st_size}")


if __name__ == "__main__":
    main()
