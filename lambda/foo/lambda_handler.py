from src import foo


def lambda_handler(event, context):
    """
    lambdaで実行するコード。

    EventBridge実行時に引き渡されるJSON型パラメータをeventで受け取り、処理fooに渡して呼び出す
    """
    foo.foo(event)
