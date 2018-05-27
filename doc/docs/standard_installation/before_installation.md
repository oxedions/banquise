# Before installation

This guide will help you setup and deploy a standard Banquise, to manage an IT infrastructure.

Please note that during this process, some terminology will be used:

* **A node** is an entity hosting software resources. It can be anything: an hardware server, a workstation, a laptop, a node, a container, etc.
* **A server** will always refer to the software server terminology: a software that listen and manage clients.
* **An OS** is an Operating System.

This guide will help you install Banquise step by step.

We will be using the reference infrastructure example provided:

- 1 x management
- 2 x nodes

And by then modifying files step by step to move it to the following infrastructure:

- 1 x management
- 1 x storage
- 3 x nodes manufacturer1 + 2 x nodes manufacturer2 + 1 x switch

If you encounter issues, do not hesitate to check the debug part of the documentation.
