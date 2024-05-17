from datetime import datetime
from typing import Dict
from zoneinfo import ZoneInfo
import os

from .util import S3Utility


def foo(args: Dict[str, str]):
    """
    /tmpにディレクトリを作成し、ファイルを書き込む
    それを文字列として読み込んで、S3にアップロードしてみる
    """

    current_at: str = datetime.now(ZoneInfo(key="Asia/Tokyo")).strftime(
        "%Y-%m-%d %H:%M:%S"
    )
    print(f"now= {current_at}")

    # lambdaは /tmp が使える
    # ただし10GBまで。
    # また書き込んだファイルは次のlambda関数実行時には引き継がれないため一時領域としてしか使えない
    # （public.ecr.aws/lambda/pythonイメージを使ったlocal dockerの場合は、起動している間は/tmpに書き込んだファイルは維持される）
    dir: str = "/tmp/hogehoge/foo"
    f: str = f"{dir}/test"

    try:
        # /tmpにディレクトリを作成
        os.makedirs(dir)
    except Exception as e:
        print(e)

    s: str = read_str_from_file(f)
    print(f"before file's text= {s}")

    # /tmpにファイルを書き込む
    write_str_to_file(f, f"{current_at}: {args['name']}")

    # 作成したファイルを試しにstrとして読み込んでS3にアップロードしてみる
    s3u = S3Utility(bucket_name="hogehoge-sample-bucket")
    s3u.write_str_to_s3(object_key_name="written_by_foo", s=read_str_from_file(f))


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
