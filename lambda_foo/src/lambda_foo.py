from datetime import datetime
from zoneinfo import ZoneInfo
import os


def lambda_handler(event, context):
    current_at: str = datetime.now(ZoneInfo(key="Asia/Tokyo")).strftime(
        "%Y-%m-%d %H:%M:%S"
    )
    print(f"now= {current_at}")

    dir: str = "/tmp/hogehoge/foo"
    f: str = f"{dir}/test"

    try:
        os.makedirs(dir)
    except Exception as e:
        print(e)

    s: str = read_str_from_file(f)
    print(f"before file's text= {s}")

    write_str_to_file(f, current_at)
    print(f"wrote text='{current_at}' to file!")


def write_str_to_file(file, s: str) -> None:
    with open(
        file=file,
        mode="w",
        encoding="UTF-8",
    ) as f:
        f.write(s)


def read_str_from_file(file) -> str | None:
    try:
        with open(
            file=file,
            mode="r",
            encoding="UTF-8",
        ) as f:
            return f.read()
    except FileNotFoundError:
        return None
