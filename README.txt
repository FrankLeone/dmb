Donders Matlab Batch (DMB)

DESCRIPTION
An extension to the SPM matlab batch system, geared towards common practices at the Donders Institute for Brain, Cognition and Behavior, such as:
- Echo combination for multi-echo experiments
- Signal checks (e.g., spikes and stability) for fMRI data
- Nuisance regressors for data cleaning        

INSTALLATION
- NOTE: DMB requires SPM8 to be installed and in the matlab path
- Download locally
- Extract
- Add path to DMB to matlab path
- Start SPM and matlab batch
- The menu should be automatically add

USAGE
- Works exactly like the original matlab batch
- Look at the examples in the "examples" dir
- Note I included the items in the menus in the default sequential order
- Note also that the SPM functions (like realign: estimate, write, and new segment) are actually references to the SPM functions, included in this menu for convenience.

CODE STRUCTURE
- Prefixes:
* dmb is the prefix for all functions in the package
* dmb_cfg is the prefix for all configurational files (dmb_cfg, dmb_cfg_defaults, dmb_cfg_get_defaults)
* dmb_menu is the prefix of all upper level menus
* dmb_item is the prefix for all actual items
* dmb_item_spm is the prefix for all items directly linking to SPM
* dmb_run is the code that is actually executed when a button is clicked
* dmb_vout processes the output of the dmb_run function, used for dependencies
- Directory structure
* The directory structure follows the button structure, including numbers for the order of buttons
- Comment structure
* The code follows the Matlab code template from generously provided by Denis Gilbert (http://www.mathworks.com/matlabcentral/fileexchange/4908-m-file-header-template)

QUESTIONS/COMMENTS/REQUESTS?
Do no hesitate to contact me through the github interface at

https://github.com/FLeone/dmb/issues

Or contact me a

f.leone@donders.ru.nl

LICENSE
This code is released under GNU GPL v3, meaning you are free to use, change, and distribute this code.

CONTACT
Frank Leone
Donders Institute for Brain, Cognition and Behavior
E-mail: f.leone@donders.ru.nl
Site: frank.leone.nl
