---
pageClass: api
sidebarDepth: 1
---

# Pline plugin API

The Pline plugin API allows to describe command-line program arguments and corresponding interface in [JSON](https://www.json.org) format.
Each option is specified with an `Object` containing one or more attributes described in this document.
The interface elements (and the resulting arguments in the command line) are generated in the same order as they appear in JSON.
::: tip
Native Javascript objects can be used instead of JSON.
Object format supports e.g. embedded comments and unquoted attribute names:
>JSON
```json
{"name": {"key": "value"}}
```
>Object
```js
{name: {key: "value"}} //some comment
```
:::
 
::: warning Glossary
+ **program** - command-line executable
+ **options**
  - additional parameters added to the program launch command 
  - descriptions of program parameters in the plugin JSON file
+ **attributes** – JSON-formatted text fields for describing plugin/program options
+ **tracked name** – name of an option in JSON (set with name or option attribute)
+ **input** – HTML input element (a textbox, checkbox or selection menu) in the generated plugin interface
+ `String`, `Boolean`,  `Array`,  `Object` – valid value types for the attributes
:::
 
## Plugin attributes
These attributes describe the program or plugin settigns.

### *program*: `String`
Name of the executable (global command or filepath in the plugin folder).

### *options*: `Array` 
`Array` can contain strings (displayed as text) and option objects (described in the next section).
You can group options to multiple “options” arrays by wrapping each `Array` to an `Object`.
The group wrapper appearance can be customized by including one of these attributes:
  - ### *group*: `String`
  options (input elements) are displayed in a collapsible section below the label `String`.
  - ### *collapsed*: `Boolean`
  sets whether the options section is initially collapsed
    + Default: `true`
  - ### *section*: `String`
  options are displayed in a bordered section below a horizontal line and label `String`.
  - ### *line*: `String`
  option inputs are displayed in a line (wrapped if necessary)
  - ### *select*: `String`
  display options in a selectable list. Same as {*type*:“select”, *title*:`String`} (see the *type* attribute).
  ::: warning Note
  Leave the `String` label empty (“”) for untitled section.
  :::

### Optional plugin attributes:
### *desc*: `String`
Description of the program.
Can include HTML and web addresses are automatically parsed to HTML links.

### *name*: `String`
Name of the program.

### *icon*: `String | Array`
Icon for the program interface.
`String` can be:
- SVG path. Example: `“M 11.193359 0.55078125 z”`
- Image data URI: Example: `“data:image/gif;base64,R0lGODlhEA…”`
- Path to image file (in the plugin folder). Example: `“images/icon.jpg”`
Multiple icon formats can be given in `Array`.

### *outfile*: `String | Object | Array`
Specifies (partial or full) name of the the expected main output file. 
You can list alternative candidates in `Array` (file selected after program execution).
::: tip
Use `Object` for conditional output naming (see [Conditionals](./api#conditionals)) or a comma-separated `String` for specifying multiple output files.
:::

### *submitBtn*: `String | Object | Array`
`String` is a label displayed on the submit button in the interface.
+ Default: `“Send job”`

Use (`Array` of) `Objects` for conditional labeling (see [Conditionals](./api#conditionals)).

### *prefix*: `String`
Specifies leading character(s) for each parameter name in the command line. 
+ Default: `“-“`

Prefix can also be set for a single option or options group.

### *valuesep*: `String`
Specifies the character separating parameter name from its value in the command line.
+ Default: `” “`

### *version*: `String`
The version of the program the plugin is written for.

### *disable*: `true`
Sets the plugin as disabled.

### *debug*: `true | String`
Write debug messages to the javascript console to keep track of plugin JSON parsing and value changes of all (if set to `true`) or one specific (if set to option name `String`) option in the interface.
+ Default: `false`

## Option attributes 
These properties are used in each JSON `Object` describing an option in the *options* `Array`.
 
### *type*: `“bool” | “tickbox” | “checkbox” | “int” | “float” | “number” | “text” | “string” | “file” | “hidden” | “select” | “output”`
Sets the type for the option (input argument).
+ Default: `"text"`

**Available option types:**
- **`“file”`** – option accepts input datafile.
::: warning Optional attributes for file inputs
* Use the *title* attribute to add custom text to the filedrop area
* Use the *desc* attribute to add custom text next to the filedata that user has added
* Use the *name* attribute to change the filename
:::
- **`“dirpath”`** – for giving the program a directory path
Use this option if the program parameter value (named via *option* attribute) needs a full path to the working directory. Otherwise works as the `“hidden”` option type.
::: tip
You can add a filename to the directory path with the *default* attribute.
:::
- **`“hidden”`** – automatically added option without user input. Use *default* attribute to set its value.
With *option* attribute, “default” sets pre-defined program arguments (`String | Number`) or flags (true/false).
::: warning Note
 * “hidden” options can use *value* attribute as alias to “default”.
 * “hidden” option with an empty/false value excludes it from the command line.
:::
::: warning Note
The program output stream (console output) will be written to text file output.log.
If the program prints its results to screen, direct it to another file: {*hidden*: “outfile.fa”, *prefix*: “>”}
:::
- **`“select”`** – list of options (or values for an option) where only one can be selected.
Additional attributes:
  - *selection*: `Array` of `String | Number | Object` items  
  Mutually exclusive list of items to choose from.  
  `String | Number` is a shorthand for `{title: String|Number, value: String|Number}`.

  Valid attributes in the selection list `Object`:  
    - *title*: `String`  
    Text to be displayed in the list.
    ::: warning Note
    *title* also sets the selection item value (unless overriden with *value*).
    ::::
    - *option*: `String | Array | Object`  
    Other program option(s) to be set when the item is selected.
    Program options can be set as {*argname*: `“argvalue”`} or as `“argname”` for `Boolean` options (command-line flags).
    ::: tip
    *title* can be omitted if *option* is set as `String`.
    :::
    - *value*: `String | Number | “no value”`  
    Sets the value for the program option/selection when this list item is selected.
    `“no value”` assigns an empty value (`“”`). When *value* attribute is omitted, `“title”` is used instead.
    - *desc*: `String`  
    Additional text (shown via info icon) for the selected item.
    - *default*: `true | String`  
    Sets the item as the initial selection.
    ::: warning Note
    *default*: `String` is a shorthand for {*title*: `String`, *default*: `true`}
    :::
    - *extendable*: `true | “configurations”`  
    Allows users to add custom options to the selection list.
    `“configurations”` allows to select or store sets of values (presets) for all the plugin options.
- **`“bool” | “tickbox” | “checkbox” | “switch”`**  
Tickbox element. User input adds/removes the option from the command line.
- **`“text” | “string”`**  
Text input box. User input is assigned to an option (see *option* attribute) and/or tracked name (*name* attribute).
- **`“number” | “int” | “float”`**  
Same as `type: “text”`, but accepts only numerical input. `“int”` restricts input to whole numbers.
::: tip
- *type*, *title* and *option* attributes can be combined to *inputType*: `String` shorthand syntax: 
```js
{number: “argname”}`
```
> Available for option types `“text”`, `“number”`, `“tickbox”` and `“select”`
- When *name* attribute is present (or *type* is `“select”`), the syntax sets just the *title* (e.g. not a command line argument).
- *type*: “default” shorthand syntax is available for option types `“output”` and `“hidden”`.
```js
{output: “outfile.fas”}
```
::::

### *title*: `String`
Shows a text label next to the input element (except for option type “hidden”).

### *option*: `String`
Sets the command-line argument name. Also sets a reference name for its value tracking (see *name* attribute).
You can include a prefix to override global *prefix* attribute. Set to empty `String` (“”) for positional arguments.
Note: options are passed to the program in the order of appearance in JSON.
::: tip
Use the *name* attribute to differentiate between multiple options with the same argument name.
:::

### *desc*: `String`
Tooltip text, displayed when hovering the title (or form element when title is missing).

### *name*: `String`
Enables option value tracking. `String` is unique reference name that can be used by other options (see e.g. “enable” and “default” attributes).
Overrides the *option* attribute as reference name for tracking.

### *enable* | *disable*: `Boolean | String | Object | Array`
Includes or excludes the program argument(s) from command line, its input element(s) from the interface, and clear the input value (revert the option to its “default” or empty value).
`String` or `Object` (or `Array` of these) define rules for conditional enabling/disabling (see [Conditionals](./api#conditionals)).
::: tip Examples
```js
{ enable: “option_name is not ticked” }
```
```js
{ disable: {“‘option name’ is more than 10”: “yes”}
```
```js
{ enable: “no tree” }
```
```js
{ enable: “option_name is disabled” }
```
:::

### *check*: `String | Object`
Checks the option value and displays the message `String` whenever the input element is empty
`Object` is a conditional in the form {`rule` : `String`}, where `rule` is a logic expression (see [Conditionals](./api#conditionals)) to check the input element value against, and `String` is the corresponding error message.

### *required*: `String | Object`
Same as the *check* attribute, except
1) checks the value and displays the error message only after the “submit” button is clicked, and 
2) an error prevents the plugin launch.

### *default*: `value | Object | Array`
Initial/default value for an option. Can be overriden by user input, unless the input element is disabled with *fixed*, *disabled* or *hidden* attribute.
:::warning Note
For text inputs, it is assumed that the default value does not need to be added to the program command line parameters, and is shown just for information when user has not inserted any value. If it’s not the case, make the program option compulsory with the *required* attribute.
:::

#### Conditionals
The value for the *default* (and many other) option attributes can change according to a logical expression (conditional) and the values of the current (or any other) option. The conditional values are defined in the plugin JSON as {`condition`: `result`} objects.
- Alternative (mutually exclusive) conditionals can be listed in array: [{`condition1`: `result1`}, {`condition2`: `result2`}, …].
- The conditional strings can use Javascript logical operators, which in the plugin JSON can be replaced with API keywords:
  + “is”/“equals” (=); “not”/“is not” (!=)
  + “contains”
  + “and” (&&), “or” (||)
  + “ticked”/“selected”/“on”/“enable” (true)
  + “no”/“off”/“disable” (false)
  + “invert” (!)
Both the `condition` and `result` strings can use the option input values via each option’s tracked name (set by the *option* or *name* attributes). Together with the logic expressions, you can construct rules to check for a value of an option and change an option attribute accordingly.
::: tip Examples
```js
{disable: {“option_name is not ticked”: true}}
```
```js
{check: {“option_name is 10”: “you typed 10”}}
```
```js
{default: {“option_name is more than other_option_name and no third_option”: “numeric_option + 0.5”}}
```
:::

::: warning Note
Wrap tracked/option names to single quotes (`“‘option name'”`) if it contains spaces. 
Wrap tracked names to escaped double quotes (`“\”optionName\””`) to use the name as text (instead of the option’s value).
```js
{“‘some argument’ equals \”some argument\”” : “The option value is now its name:\”some argument\”.” }
```
:::

### *fixed*: `“yes” | true | String | Object | Array`
Input element cannot be changed by user. `String` or `Object` (or `Array` of these) define rules for conditional fixing (see *enable* attribute).
If input element is disabled by *fixed*, the default value (see *default* attribute) overrides input value from user.

### *format*: `“invert” | expressionString | Object`
Do some postprocessing with the value of this option (this_option_name) before passing to the program.
`“invert”` is same as `“invert this_option_name”` (only useful for `Boolean` type options).
`expressionString` is a fixed value or javascript code for formatting.
> Example
```js
{ format: “this_option_name + \’ concatenated text\'”. }
```
`Object` can be used for conditional formatting (see [Conditionals](./api#conditionals)):
```json
{ “this_option_name is less than 0”: “Math.abs( this_option_name )” }
```
:::warning Note
* the type of the variable this_option_name is defined by *type*: `String | Boolean | Number`
* in Javascript expression, use spaces around `option_name`, `\’quoted text\’` and other syntax tokens
:::

### *line*: `Boolean`
Options marked with *line* attribute are displayed in one line (alternative to grouping with the *line* attribute)

### *prefix*: `String`
Option-specific command-line prefix (overrides global *prefix* attribute).

::: tip
You can inspect/debug imported plugins via Javascript console:
```js
console.log( Pline.plugins[“plugin name”] ); //plugin datamodel object
console.log( Pline.plugins.pluginName.options.optionName() ); //current input value
```
:::

## Wasabi-specific attributes
[Wasabi](http://wasabiapp.org) extends the Pline plugin API with some attributes and modifications.

- Plugin attributes
  + ### *menudesc*: `String`
  Short description of the program.
  Displayed as tooltip in the Wasabi tools menu (on mouseover).

  + ### *icon*: `String | Array`
  Wasabi displays the program icon in the tools menu and in the interface window.
  These can be given as `Array` with an SVG and img/png (recommended size 25*25px).

  + ### *outfile*: `String | Object | Array`
  This attribute tells Wasabi which file to use for the “Open” button in the analysis library.
  Use comma-spearated `String` for opening a dataset with multiple files (e.g. `"alignment.fas,tree.nwk"`).

  + ### *translate_names*: `Boolean`
  If set to true, all sequence names in input file(s) are converted to simple IDs (“seq1”, “seq2”, …),
  which are translated back to the original names when the output is opened in Wasabi.
  > Default: `false` (retain input taxa names, with spaces converted to underscore)

  + ### *enable*: `“tree” | “sequence” | “data”`
  The plugin is disabled until tree/sequence/one of these is imported  (e.g. required for input file).

  + ### *libraryname*: `String`
  Default name for the stored results in the analysis library
  > Default: `“my analysis”`
  
- Additional attributes for __*type*: "file"__ input options:
  + ### *source*: `“current sequence” | “current tree” | “current data” | “fileinput”`
  Sets input file data source: either currently imported dataset or a local file added by the user (using the file input).
  > Default: `“current sequence”`

  + ### *fileformat*: `“fasta” | “newick” | “extended newick” | “phyloxml” | “hsaml” | “phylip” | “nexus” | “original”`
  Input file will be converted to specified format before feeding it to the program.
  Use `“original”` to skip file conversion.
  > Default: `“fasta”` (for sequence data) | `“newick”` (for tree)
  ::: tip
  * Use multiple (`[“fasta”,“newick”]`) or merged (`“phyloxml”`) file formats if both tree and sequence data is expected.
  * `inputType: “source”` shorthand syntax can be used for fileinputs:
  ```js
  {file: “filedrop”}
  ```
  :::

- Conditionals
Wasabi adds predefined option names `“tree”`, `“sequence”` and keywords `“DNA”`, `“RNA”`, `“codons”`, `“protein”`.  
These can be used to check for the data type and the type of sequence that is currently imported in the Wasabi interface:
```json
//example conditionals
{“sequence and no tree”: “ticked”}
{“sequence is DNA”: 0.5}
```
::: tip Note
Don’t use the Wasabi reserved keywords (e.g. "tree") as an option __*name*__ attribute
:::

The `“tree”`/`“sequence”` keywords can also be used to check the content of user-supplied file data.
Remember to quote the keywords when used in this form:
```json
{“fileInputOption contains \”sequence\””: “newValue”}
```
<script>
/*
TODO:
* type:hidden=>shortcuts
* plugin=>stdout:filename|condit (default:output.log) (replaces ">..." hidden option value, ignored when next step uses pipe, added ot outFiles)
* plugin=>outFiles:str|condit|arr examples: 'fname.txt', {'optName':'optName.rootname + .txt'}, ['fname1', 'optName or defaultname.txt']
* option=>outfile:true|condit (added to outFiles: true=input, condit=dynamic outfilename, e.g. optName+extension (extension=computed hidden helperval))
* rename/add plugin attrs: submitBtn, translateTaxa, libraryname=>jobName, valueSep, info, configFile, configParam, category, url, outFile, stdout
* group => merge:true => applies to all options
* checkbox:value[] | select:disable,multi,caption | group/option=>css:'' | plugin:configFile | type:dirpath, prefix:> => type:hidden
* remove types: textbox/switch
* /select:configurations => builtin (remove select:extendable); tip: select+input; 1-char icons ; multi-select(multi:true=',') ; selitem:show|hide ; caption:str (initial selection title, default:"Select...")
* file value = filename (name=>value); default attr; API 'type'; -[filetypes arr]; -current,-data(sequence/tree); shorthand=opt; require opt
* file source=filedrop+fileselect(=import for Wasabi); fileformat=>format(Wasabi); 
* conditional: optname "datatype is" ... (Wasabi) | 'imported sequence/tree' (Wasabi)
* file "title":in dropbox/next to button | "desc":  on hover
* conditionals: this; 1word names; singlequotes | value = quoted default
* "desc" attr for group|section|line
* remove options group|section|line attr from plugin attr
* plugin attr: "category" (menugroup)
* translate_names=>translate_taxa
* same "option" name => merge: true(=",")|false(=duplicate; default)|valuesep(str)
* order: "first"|"last"
* line/group/section: string|true(='')|object(=''; {}=>options:{})
* add type: info:string => infoicon with hover text
* text opt: width: 'auto'|'...px'
* attr => option:	can include prefix (example: '--optname')
* selection: => show/hide: conditional (dynamically show/hide selection item)
*/
</script>