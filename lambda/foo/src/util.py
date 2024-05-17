from typing import List
import boto3


class S3Utility:

    def __init__(
        self,
        bucket_name: str,
        is_lambda: bool = True,
        aws_credential_profile_name: str = None,
    ):
        self.aws_credential_profile_name = aws_credential_profile_name
        self.bucket_name = bucket_name

        if is_lambda:
            # lambda上で動かす場合はsession不要
            s3 = boto3.resource("s3")
            self.bucket = s3.Bucket(bucket_name)
            self.client = boto3.client("s3")
        else:
            session = boto3.session.Session(profile_name=aws_credential_profile_name)
            s3 = session.resource("s3")
            self.bucket = s3.Bucket(bucket_name)
            self.client = session.client("s3")

    def list_s3_object(
        self,
        object_key_prefix: str = "",
        delimiter: str = "/",
    ) -> List[str]:
        """
        S3の特定キー（パス）直下に存在するファイルの一覧を取得する
        """
        obj = self.client.list_objects_v2(
            Bucket=self.bucket_name, Prefix=object_key_prefix, Delimiter=delimiter
        )
        return [content["Key"] for content in obj["Contents"]]

    def read_str_from_s3(self, object_key_name: str) -> str | None:
        """
        S3のファイルを単純なテキストとして読み込んで返す
        """
        obj = self.bucket.Object(object_key_name)
        try:
            response = obj.get()
        except:
            return None

        body = response["Body"].read()
        return body.decode("utf-8") if body else None

    def write_str_to_s3(
        self,
        object_key_name: str,
        s: str,
    ) -> any:
        """
        テキストをS3オブジェクトとして書き込む
        """
        obj = self.bucket.Object(object_key_name)
        response = obj.put(Body=s)
        return response

    def delete_s3_object(self, object_key_name: str) -> None:
        """
        S3オブジェクトを削除する
        """
        self.client.delete_object(Bucket=self.bucket_name, Key=object_key_name)
