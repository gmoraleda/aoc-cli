# `Advent of Code - cli`

![](https://github.com/apexatoll/aoc-files/blob/master/demo.gif)

aoc-cli is a command-line interface built in Ruby for Advent of Code puzzles.

aoc-cli has many features and allows for complete interaction with AoC from within the terminal.


## Main Features
- Download puzzles as markdown and raw inputs directly from the command line
- Submit answers for puzzles and receive feedback
- Track progress through your calendar file which is automatically updated as you progress
- View data about how you answer puzzles, for example your previous attempts, how long it takes to solve a puzzle successfully and how many attempts it took you
- Inputs and puzzles are cached locally to prevent strain on AoC server
- Hot keys to open solution megathreads in Reddit if you get stuck
- Support for multiple AoC accounts by use of session-key aliases


## Installation

Install gem

```bash
$ gem install aoc_cli`
```

Manual install

```bash
$ git clone "https://github.com/apexatoll/aoc-cli"
$ cd aoc-cli
$ rake build install
```

## Setup

### Finding your Session Key

To use aoc-cli you must first find and store your unique session cookie. To find this, log into the Advent of Code website as usual and load any page. 

Open developer tools and open the network tab. Refresh the page and you should see a file that contains your session cookie.

It will contain a field that looks something like:

```
cookie: session=ALPHANUMERIC STRING
```

This is unique to your account, and allows aoc-cli to interact with the AoC server - do not share this!


### Storing your Session Key

- Copy the session key (including "session=") to the clipboard and open your terminal
- Run the following command

```bash
aoc -k "your key" 

```

- AoC-cli stores this key under the alias 'main' by default. 
- To store the key under a different alias use the `-u` or `--user` flags followed by the desired alias.
- Session keys are stored in the aoc config file located at `~/.config/aoc-cli/aoc.rc`.

- Keys can be stored manually in your config file using the format:

```bash
cookie=>$alias=>$key
```

For example:

```bash
cookie=>account2=>1234abc
```

### Default Alias

aoc-cli allows for multiple keys to be stored within the config file. 

By default, the key under the "main" alias is used when initialising year directories and another alias is not specified

To see which alias is currently deafult run `aoc -U` or `aoc --default`

- You can update the default alias by running 

```bash
aoc -U $new_default_alias
```

For example:

```bash
aoc -U account2
```

Alternatively you could add the following line to your config file

```bash
default=>account2
```

## Usage

aoc-cli is designed to run in a file-tree generated by the interface. 

There are two types of directories
1. Year directories
	- These contain your calendar and all day subdirectories
2. Day subdirectories
	- These contain the puzzles, your input and your code


## Initialising the Year

To begin using the cli you must first initialise the year directory. 

aoc-cli will intialise within your current working directory, so first create a directory for the year and cd into it

```bash
mkdir 2020
cd 2020
```
- Initialise the year directory using the command 

```bash
aoc -y 2020
```

This will set the session key for the year directory to the default alias. To use a different AoC account run:

```bash
aoc -y 2020 -u $alias
```

This command will create necessary metafiles, download the year calendar and fill it with your current progress (if any). This is stored in a markdown file in the year directory.

By default, your stats in the leaderboard are also added to this file. To turn this off add the line `include_leaderboard=>false` to your config file.


## Initialising a Day

You can now get day data! 

To fetch puzzle instructions and inputs you can run the following command from within the year directory

```bash
aoc -d $day_number
```

This command performs the following actions

- Creates a day subdirectory
- Fetches the puzzle as markdown
- Fetches raw puzzle input
- The time you downloaded the puzzle is logged

All puzzles and inputs are cached in aoc-cli on a per-user basis. This means that if you have previously initialised this day under this alias before, your puzzle and input will be transferred from the cache locally rather than downloading from the aoc server.


## Solving Puzzles

From the day subdirectory you can attempt to solve puzzles by running the command 

```bash
aoc -s $answer
```

You will then receive one of three responses

1. The answer is correct
2. The answer is not correct
3. You have time to wait before submitting an answer

If your answer is correct, aoc-cli will automatically update the puzzle instructions and your calendar file. Additionally aoc-cli will calculate how long and how many attempts it took to solve the puzzle (see the Tables section)

Incorrect attempts will be logged along with any hint as to whether your answer was too high or too low. 

If you have sent multiple incorrect attempts AoC will ask you to wait before trying again - be patient!


## Tables

aoc-cli uses a local database to store information about your progress with puzzles. There are two main databases of use:

1. Your attempts
2. Your stats


### Attempts

Previous attempts for a puzzle can be viewed from the day directory by the use of the command

```bash
aoc -a 
```

To specify which attempts to show from outside the day subdirectory you can use the command

```bash
aoc -a -u $user_alias -Y $year -D $day -p $part
```

Data is shown in a formatted table with incorrect attempts shown in red and the correct answer in green.

![](https://github.com/apexatoll/aoc-files/blob/master/attempts.png)

### Stats

aoc-cli also tracks data related to your performance in puzzles, namely:
- The time taken to complete a puzzle
- How many attempts it took

To view this, run the following command from the day subdirectory

```bash
aoc -S 
```

To view the stats for the year as a whole run the same command from the year directory. Flags can be also be added manually for showing data for other users, years and days in a similar way to that of the attempts table

![](https://github.com/apexatoll/aoc-files/blob/master/stats.png)

## Reddit Integration

You can run the command `aoc -R` from the day subdirectory, or by manual flags to open the solution megathread for the specified day in Reddit

If one is installed, aoc-cli will default to opening the thread within a reddit-clu such as RTV or TTRV. If one isn't found however, the thread will be opened within your default browser.

To always open megathread in your browser run

```bash
aoc -B true
```

## Vim Integration

if you use vim you may wish to set a keybinding to automatically run your code and submit it for validation once you have solved a puzzle.

Using Ruby as an example, you could add the following line to your .vimrc:

```vim
autocmd filetype ruby nmap <silent><leader>ac :! aoc -s $(ruby %)<CR>
```

Executing leader + ac would then run your program and send the answer to the server for verification (as long as your program only outputs an answer and no other text). 

Do not send endless attempts - only send when you are comfortable with your answer!
 

## All Flags

| Flag Short | Flag Long      | Action                                    |
|------------|----------------|-------------------------------------------|
| `-a`       | `--attempts`   | Print attempts table                      |
| `-b`       | `--in-browser` | Open reddit in browser                    |
| `-d`       | `--init-day`   | Initialise day subdirectory               |
| `-h`       | `--help`       | Show help screen                          |
| `-k`       | `--key`        | Store session key                         |
| `-p`       | `--part`       | Specify part for aoc command              |
| `-r`       | `--refresh`    | Refresh calendar (year dir)               |
|            |                | Refresh puzzle (day subdir)               |
| `-s`       | `--solve`      | Solve puzzle                              |
| `-u`       | `--user`       | Specify alias for aoc command             |
| `-y`       | `--init-year`  | Initialise year directory                 |
| `-B`       | `--browser`    | View reddit browser setting (no argument) |
|            |                | Set reddit browser (with argument)        |
| `-D`       | `--day`        | Specify day for aoc command               |
| `-R`       | `--reddit`     | Open solution megathread                  |
| `-S`       | `--stats`      | Print stats table                         |
| `-U`       | `--default`    | View default alias (no argument)          |
|            |                | Set default alias (with argument)         |
| `-Y`       | `--year`       | Specify year for aoc command              |


## Acknowledgments

I am in no way affiliated with AoC, but I would like to take this opportunity to thank the creator Eric Wastl for the taking the time and great effort to produce these fantastic puzzles!

Please note that requests are hard-coded to be throttled to a maximum of 1 HTTP request per 5 seconds. This is to ensure that the AoC server is not overloaded with requests. Please do not try and change this - it is to protect the server!

Please let me know if there are any bugs or issues with the cli within the issues section - I will try to address them as quickly as I can
