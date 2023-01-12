# Setup & Installation

There are two ways of development in ROHD. First, You can run ROHD on GitHub codespace or local machine. 


## Setup on Github Codespace

1. Navigate to https://github.com/intel/rohd and click on Codespaces. 

![step 1](assets/CodespaceSetup/step1.PNG)

2. You will be navigate to a page where GitHub will spin up the container for you. Please wait patietly while GitHub preparing your server.

![step 2](assets/CodespaceSetup/step2.PNG)

3. When your space is ready, you will see a visual studio code running on your browser.

![step 3](assets/CodespaceSetup/step3.PNG)

4. Run `dart pub get` on the terminal of the visual studio code to pull your setup.

![step 4](assets/CodespaceSetup/step4.PNG)

5. Open up `example` folder on the left navigation panel and click on `example.dart` to bring forward the first example of ROHD. After that, navigate to the main function at below of line 58 and click on the `Run` at `Run | Debug`.

![step 5](assets/CodespaceSetup/step5.PNG)


If you can see SystemVerilog code pop up on the terminal. Well, you have successfully set up your development environment on the cloud.

6. To delete the codespace, go back to https://github.com/intel/rohd and click on codespace just like step 1. But this time, you will see more options. Click on the delete option to delete codespace.

![step 6](assets/CodespaceSetup/step6.PNG)