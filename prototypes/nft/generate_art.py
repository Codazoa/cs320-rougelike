from tracemalloc import start
from PIL import Image, ImageDraw
import random

def random_color():
    return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))

def interpolate(start_c, end_c, factor: float):
    recip = 1 - factor
    return (
        int(start_c[0] * recip + end_c[0] * factor),
        int(start_c[1] * recip + end_c[1] * factor),
        int(start_c[2] * recip + end_c[2] * factor),
    )


def generate_art():
    print("Generating Art...")

    # Define Image Presets
    image_size_px = 128
    padding_px = 12
    image_bg_color = (255, 255, 255)
    start_color = random_color()
    end_color = random_color()
    # Create the image
    image = Image.new("RGB", size=(image_size_px, image_size_px), color=image_bg_color)

    # Create drawing interface
    draw = ImageDraw.Draw(image)
    points = []

    # Generate the points
    for _ in range(10):
        random_point = (random.randint(padding_px, image_size_px - padding_px), random.randint(padding_px, image_size_px - padding_px))
        points.append(random_point)

    # Draw the lines
    thickness = 0
    n_points = len(points) - 1
    for i, point in enumerate(points):
        random_point_1 = point

        if i == n_points: # If it's at the end, then our point is the first point
            random_point_2 = points[0]

        else:                    # Otherwise, our point is the next point
            random_point_2 = points[i + 1]

        line_xy = (random_point_1, random_point_2) # Define the two points the line will draw from and to
        color_factor = i / n_points
        line_color = interpolate(start_color, end_color, color_factor)
        thickness += 1
        
        draw.line(line_xy, fill=line_color, width=thickness) # Put the lines in the png

    # Save the image to the directory
    image.save("test_image.png")


if __name__ == "__main__":
    generate_art()