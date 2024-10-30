## Style Guide
- Any new code must have comments clearly describing what the code is doing. If references are required, place the references in comments where the reference is being used. If equations within a reference are being utilized, place the equation number after the line(s) of code where it is executed. 
- If any new functionality is added and this new functionality requires a new input is needed or creates additional outputs, this functionality must be added to the docstring at the beginning of the code. The format follows:
% "input_variable_name": description of the input (variable_type i.e. double, string, etc)
%    default: the_default_value_of_the_input

Example:
% "z0": reference impedance of the S-parameters (double)
%    default: 50

- Functions nested within the code are placed after the main body of the code.

## Open Source License and Contributor License Agreement

This project is licensed under the terms of the Apache 2.0 license.  
All contributions to this project shall be submitted under a valid and applicable IEEE Contributor License Agreement (CLA) and licensed under the terms of the BSD3 License. 

If you have not done so, please submit your signed CLA to [oscontrib@ieee.org](mailto:oscontrib@ieee.org): [Individual CLA](https://opensource.ieee.org/community/cla/bsd3/-/blob/master/IEEE%20Entity%20CLA_BSD-3%20License_v2.0_01012020.pdf), [Entity CLA](https://opensource.ieee.org/community/cla/bsd3/-/blob/master/IEEE%20Entity%20CLA_BSD-3%20License_v2.0_01012020.pdf). 
You will receive a CLA number from IEEE staff when your CLA has been accepted.

## Milestones, Issue Boards, and Labels

If you are looking to find a way to contribute to our project, please first look over our milestones and issue boards to see if your feature or bug has already been labeled.  

If you want to contribute a new feature or bug fix that is not already labeled, it is best to first create an issue and our team will triage it by possibly requesting that you provide additional information as well as labeling it appropriately. Please note that if there are UI updates or bugs identified, please consider including any mockups or screenshots if possible.

## Merge Request Criteria
The following are our criteria for submitting merge requests:
- Your merge request shall be associated with an issue that defines the bug or feature that your merge request fixes or adds.
- All commits in your merge request shall be cryptographically signed (i.e., `git commit -S`).
- You should include a test or tests in your merge request.
- Your merge request should update any relevant documentation.
- Try to keep the amount of changes you make in a single merge request as small as possible.

## Merge Request Workflow
Please use the following workflow when submitting merge requests:
1. Fork our project into your personal namespace (or group).
2. Create a feature branch in your fork.
3. Write any appropriate continuous integration tests.
4. Push the commit(s) to your working branch in your fork.
5. Squash commits into a small number of logically organized commits, keeping the commit history intact on shared branches.
   - Please try to have fewer than 15 commit messages per merge request.
6. Submit a merge request (MR) to our project's default branch:
   - Merge request title should describe the change you wish to make.
   - Merge request descriptions should give the reason for the change.
   - Use complete URLs to issues and other MRs, milestones, etc.
   - Include the complete path when referencing files within this repository (no URL required).

## Communicating with Us
The best way to ask questions or submit changes is to email Jason Ellison directly with Josh Gay on copy. 
- jason.j.ellison@ieee.org
- j.gay@ieee.org