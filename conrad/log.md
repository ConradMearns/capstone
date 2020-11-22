# #9-15
The meeting today went well, we planned out a lot of work to be done. There's still so much that needs to be researched but it looks like it will all be doable.

I'm taking on getting a "Hello World" mod running in Farming Simulator. I don't know how to start this yet, the disc Dev gave me won't work on my PC _and_ I'm running NixOS...

We've emailed Bolden about the Snapshots so that we can start preparing for them.

# 9-22

Getting Farming Simulator's editor set up on Linux wasn't oo bad. Everything seems to run fine through Wine and on NixOS the setup is still just as easy. Running FS through Steam requires proton (im using 5.0.9) but this is also trivial to ste up if you know where the setting is.

Have to edit ./.local/share/Steam/steamapps/compatdata/787860/pfx/drive_c/users/steamuser/My Documents/My Games/FarmingSimulator2019/game.xml to enable developer controls.

 /home/conrad/.local/share/Steam/steamapps/compatdata/787860/pfx/drive_c/users/steamuser/My Documents/My Games/FarmingSimulator2019

My mod got loaded but I wasn't able to see proof of my lua script executing. How do I test this?



# 9-29

This documentation is terrible... The most descriptive item about console commands that I've found was here:
https://gdn.giants-software.com/thread.php?categoryId=22&threadId=8514

I got the mod working! I'll  need to do a writeup and explain how to replicate this, but it's not too difficult. It's just incredibly difficult to find a good source of information.

In order to support future work with preforming more intensive simulations (like soil erosion + also to allow developers to build tools in ANYTHING not just lua), I'll work on finding a way to "call out" of Farming Simulator into some other API, REST would be helpful.



# #10-16


I now know that we are using Lua 5.1 which is sandboxxed

```lua

-- get the version
print(_VERSION)

-- test default library facilities
print(math.sqrt(64))

-- testing string->code
f = loadstring("i = i + 1")
i = 10
print(i)
f()
print(i)
-- this outputs 10, then 11. success!

-- https://apocrypha.numin.it/talks/lua_bytecode_exploitation.pdf
-- maybe we can break lua?
-- this causes the module not to compile...
print(=tostring(string.upper))


-- we may be able to call load file, but Im not sure what the path would be...
g = loadfile("")
g()
g("hello!")

-- small.lua is
-- function foo (x)
--     print(x)
-- end


print(io.open("cyberxxx", "r"))
-- we cannot call io.open with "r"

local c = assert(io.open("cyberxxx", "w"))
c:write("hello!")
assert(c:close())
-- did this work? I cant remember. I think failure is the only thing that happened
-- it worked! as if thats helpful tho lmao
-- well, maybe if we write code into FS, we can save the info to file as to preserving

```



5.1 escape
https://gist.github.com/corsix/6575486

5.1 escape
https://github.com/erezto/lua-sandbox-escape

seems to get close

# #11-?

- been working on the outline of the wiki and creating a list of things that need done. This is what I have so far

- Links to Logbooks
- Minutes
- Handoff materials
- Demo/vids
- Update Schedule

Which means I need to also flesh out my  logbook, recompile it, scan in handwritten notes, etc etc. dang

I'm not sure what needs to be included in 'handoff materials' yet. I've just been perusing old resources that our team accidentally found and we've that this project is so much older than what we thought (by about a year, but still).

There's very, very little to show for all the combined effort of all of the history of this project. That being said, our team has really been struggling to work with the Farming Simulator API to get anything integrated, it's consumed probably 90% of our time.


# #11-16

Working on the wiki, it's really frustrating to only now find other hints of the scope of what we've been trying to do. I filled out more about the background to the project, stuff about precision ag etc. The most frustrating aspect about all of this is how little anyone else seems to care about this project. Bolden STILL has not replied to our questions. I'm worried that we will be judged harshly because we didn't do our project "correctly".

This hasn't been the greatest insult to my time that the University has thrown at me though, Software Engineering and Algortihms are still the kings of worst "education" experiences I've ever had to endure, but this is pretty close up their. 

At least with the other two classes, we actually received feedback.

