# azure

Upload files to blob storage using HMAC signed request, to get over ResourceNotFound errors and other authentication errors I was facing when attempting to use an old curl script to upload simply using SAS key

It stems from this:
https://social.technet.microsoft.com/Forums/en-US/450a3d29-9237-4b31-9e15-f5ebd136dec2/operations-on-blob-storage-using-curl-commands-from-linux?forum=windowsazuredata

With a modification to upload file rather than just creating a container.
