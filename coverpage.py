import argparse
import re
import os
from docx import Document
from docxcompose.composer import Composer
from docx.opc.exceptions import PackageNotFoundError
import sys


def config_args():
    parser = argparse.ArgumentParser(description="combine cover and text pages in docx")
    parser.add_argument("cover", help="path to cover docx")
    parser.add_argument("text", help="path to text docx")
    parser.add_argument("-o", "--output", required=True, help="path to output docx")
    return parser.parse_args()


def main():
    args = config_args()
    if not re.match(r".+\.docx$", args.output):
        print("ValueError: output file is not docx", file=sys.stderr)
        sys.exit(1)
    try:
        cover_path = os.path.join(os.getcwd(), args.cover)
        text_path = os.path.join(os.getcwd(), args.text)
        output_path = os.path.join(os.getcwd(), args.output)
        cover = Document(cover_path)
        composer = Composer(cover)
        text = Document(text_path)
        composer.append(text)
        composer.save(output_path)
    except PackageNotFoundError as e:
        print("PackageNotFoundError: {}".format(e), file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
