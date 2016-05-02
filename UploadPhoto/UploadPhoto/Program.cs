using Microsoft.WindowsAzure.Storage;
//using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage.File;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using NLog;

namespace UploadPhoto
{
    class Program
    {
        private static string DefaultEndPointProtocol = "";
        private static string AccountName = "";
        private static string AccountKey = "";
        private static string DirPath = "";
        private static string FileExtension = "";
        //private static string ContainerName = "";
        private static string ShareReference = "";
        private static string ShareDirectory = "";

        // Set up logging
        public static Logger logger = NLog.LogManager.GetCurrentClassLogger();



        public static int Main(string[] args)
        {
            var program = new Program();

            // Initialize application by reading configuration file
            if (!InitAppSettings(System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetEntryAssembly().Location), "UploadPhotoApp.exe")) return -1;

            DirectoryInfo di = new DirectoryInfo(DirPath);
            string connectionstring = string.Format("DefaultEndpointsProtocol={0};AccountName={1};AccountKey={2}", DefaultEndPointProtocol, AccountName, AccountKey);
            // Compress the directory's files.

            int i = 0;
            foreach (FileInfo fi in di.GetFiles(FileExtension))
            {
                //logger.Info("Uploading file {0}  ...", fi.FullName);
                if (UploadToFileStorage(fi, connectionstring, ShareDirectory))
                {
                    //logger.Info("... done. Deleting file now...");
                    try
                    {
                        fi.Delete();
                        //logger.Info("Deleted {0}", fi.FullName);
                    }
                    catch (Exception e)
                    {
                        logger.Error("Error deleting file : {0} {1} {2}", fi.Name, e.Message, e.InnerException.Message);
                    }
                }
                else
                {
                    logger.Error("Error Uploading {0}", fi.FullName);
                }
                i++;
            }

            logger.Info("Number of files uploaded = {0}", i.ToString());
            return program.Run();
        }

        private static bool InitAppSettings(string currentDirectory, string applicationName)
        {
            // Open RaspberryPiGateway.exe.config file for device information
            try
            {
                logger.Info("Trying to open configuration file.");
                logger.Info("Current Directory {0}", currentDirectory);
                logger.Info("Application Name {0}", applicationName);
                string exePath = System.IO.Path.Combine(currentDirectory, applicationName);
                var configFile = ConfigurationManager.OpenExeConfiguration(exePath);
                var appSettings = ConfigurationManager.AppSettings;
                if (appSettings.Count == 0)
                {
                    // We cannot run without the connection parameters from 
                    logger.Info("AppSettings is empty.");
                    return false;
                }
                else
                {
                    //foreach (var key in appSettings.AllKeys)
                    //{
                    //    // logger.Info("UploadPhoto config file key: {0} Value: {1}", key, appSettings[key]); // security risk
                    //}
                    // Read relevant keys from the config file and store in a variable

                    DefaultEndPointProtocol = ConfigurationManager.AppSettings.Get("DefaultEndPointProtocol");
                    AccountName = ConfigurationManager.AppSettings.Get("AccountName");
                    AccountKey = ConfigurationManager.AppSettings.Get("AccountKey");
                    DirPath = ConfigurationManager.AppSettings.Get("DirPath");
                    FileExtension = ConfigurationManager.AppSettings.Get("FileExtension");
                    //ContainerName = ConfigurationManager.AppSettings.Get("ContainerName");
                    ShareReference = ConfigurationManager.AppSettings.Get("ShareReference");
                    ShareDirectory = ConfigurationManager.AppSettings.Get("ShareDirectory");
                    // All settings retreived, we can return
                    return true;
                }
            }
            catch (ConfigurationErrorsException e)
            {
                logger.Error("Error reading app settings: {0} {1}", e.Message, e.InnerException.Message);
            }

            // Something didn't go right...
            return false;
        }

        public int Run()
        {
            return 0;
        }





        private static bool UploadToFileStorage(FileInfo zipFile, string storageConnectionString, string shareDirectory)
        {
            // Connect to the storage account's blob endpoint 

            bool bRV = false;

            try
            {
                CloudStorageAccount account = CloudStorageAccount.Parse(storageConnectionString);
                CloudFileClient client = account.CreateCloudFileClient();
                //CloudBlobClient client = account.CreateCloudBlobClient();
                // Create the blob storage container 
                CloudFileShare share = client.GetShareReference(ShareReference);
                if (share.Exists())
                {
                    CloudFileDirectory rootDir = share.GetRootDirectoryReference();
                    CloudFileDirectory shareDir = rootDir.GetDirectoryReference(ShareDirectory);

                    if (shareDir.Exists())
                    {
                        CloudFile cfl = shareDir.GetFileReference(zipFile.Name);
                        if (cfl != null)
                        {
                            if (cfl.Exists())
                            {
                                logger.Warn("File already exists {0}", zipFile.Name);
                            }
                            else
                            {
                                logger.Info("Uploading file {0}", zipFile.Name);
                                using (FileStream fs = zipFile.OpenRead())
                                    cfl.UploadFromStream(fs);
                            }
                        }
                        else
                        {
                            logger.Warn("Null value of cfl returned {0}", zipFile.Name);
                        }
                    }
                    else
                    {
                        logger.Warn("Directory share does not exists {0}", ShareDirectory);
                    }
                }
                else
                {
                    logger.Warn("File share does not exists {0}", ShareReference);
                }
                //CloudBlobContainer container = client.GetContainerReference(blobContainerName);
                //container.CreateIfNotExists();

                //net use [drive letter] \\nkimages.file.core.windows.net\linuxshare /u:nkimages [storage account access key]
                //https://nkimages.file.core.windows.net/linuxshare 

                //// Create the blob in the container 
                //CloudBlockBlob blob = container.GetBlockBlobReference(zipFile.Name);

                //// Upload the zip and store it in the blob 
                //using (FileStream fs = zipFile.OpenRead())
                //    blob.UploadFromStream(fs);
                bRV = true;
            }
            catch (Exception e)
            {
                logger.Error("Error uploading file to storage: {0} {1}", e.Message, e.InnerException.Message);
            }
            return bRV;
        }
    }
}
