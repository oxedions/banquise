# FAQ

## Why is Banquise using Salt?

Few open sources deployment solutions were tested before Salt. Salt was chosen because it was powerful and flexible enough to handle something like Banquise. Also, the pure Jinja2 way of Salt should help in the future.
Last point: debugging Salt is easy compared to other solutions.

## There is no High Availability or Failover, do you plan to add it?

Yes and no. HA/Failover and Multi-Islands systems are scheduled. However, choice was made to first consolidate the Standalone version and wait for a specific demand before developing it.

## Salt is compatible with many Linux distributions, but not Banquise. Is it planed also?

Yes. Banquise is already compatible with RHEL/Centos for management nodes, and RHEL/Centos/Fedora/Ubuntu/Debian for client nodes. Other distributions could be added if their is a demand.

## Is there a way to use OpenHPC rpm into Banquise?

Yes, you just need to develop a simple module that add this repository. If enough people need it, it will be added into main part of Banquise.

## Do you plan to support other operating systems than Linux, has Salt handle that ?

If there is a demand, yes, as long as files are opensources. Banquise is open in code but also in philosophy: it is made for everyone.
