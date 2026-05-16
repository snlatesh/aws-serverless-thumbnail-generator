import boto3
from PIL import Image

s3 = boto3.client('s3')

DEST_BUCKET = 'thumbnail-images-bucket-yourname'

def lambda_handler(event, context):

    for record in event['Records']:

        bucket_name = record['s3']['bucket']['name']
        file_key = record['s3']['object']['key']

        download_path = f'/tmp/{file_key}'
        upload_path = f'/tmp/resized-{file_key}'

        s3.download_file(bucket_name, file_key, download_path)

        image = Image.open(download_path)

        image.thumbnail((200, 200))

        image.save(upload_path)

        s3.upload_file(
            upload_path,
            DEST_BUCKET,
            f'thumbnail-{file_key}'
        )

    return {
        'statusCode': 200
    }