# MultiGet

# MultiGet
MultiGet is a download boosting command line tool.

# Usage

  - Compile using provided xCode project
  - In the command line navigate to the MultiGet binary in the project's Products Directory
  - Run the binary without arguments to see the options
  ```sh
  $ ./MultiGet
  [OPTIONS] url
--output string
    Write output to <file> instead of default
--chunk_size int
     Size in bytes of download chunks. Defaults to 1MB.
--num_chunks int
      Number of chunks to download. Defaults to 4.
--max_size int
        Maximum size in bytes to download. Will respect --chunk_size  or --num_chunks options. Will use --num_chunks if both are set.
  ```
  - Add the required file url that supports HTTP Range
  - Add any additional options. 
  ```sh
  $ ./MultiGet http://bddfcecf4927511.bwtest-aws.pravala.com/384MB.jar --output ./MyOutput --max_size 10000000
  ```
  - After running the downloaded file will be located in the specified output directory or in ./MultiGet/<file>
