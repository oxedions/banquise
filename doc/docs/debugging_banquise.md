# Debugging Banquise

Banquise is fully based on Salt Stack.

To debug Banquise, please understand the rendering order of Salt, and then use the provided debugging information below to investigate the faulty part. The global strategy is to identify which step is failing, and then use logs and test samples to solve issue.

Remember: the saltmaster is only some kind of files provider, rendering process is done on minions.

## Salt rendering order

pillars -> top.sls pillars (who can access which pillars) -> top.sls states (who apply which states) -> states -> finalize with grains -> apply

## Gather information and check data

When having an issue, best way if issue is not clearly specify is to check all elements one by one.

### Check pillars

Pillars contains data, but also some logic that could fail. They must be checked.

Pillars can be rendered on a specific target to display their content. Best target is a master node, has these nodes commonly have access to all pillars.

For example, to ask Salt to render management1 pillars, and display them, use:

```bash
salt 'management1*' pillar.items
```

First thing is then to scroll at the top of the output and check their is no errors, like:

```bash
_errors:
    - Rendering Primary Top file failed, render error:
```

or

```
_errors:
    - Rendering SLS 'engine/engine_connect' failed. Please see master log for details.
```

Then, if error is not display here, check master logs at /var/log/salt/master. For example, content can be:

```
ParserError: while parsing a block mapping
  in "<string>", line 15, column 2:
     dhcp_server:
     ^
expected <block end>, but found '<block mapping start>'
  in "<string>", line 17, column 4:
       management: auto
       ^

; line 5
```

To get more information, use:

```bash
salt-call -l trace
```

Recommended is (because trace provides too much non useful information):

``` bash
salt-call -l debug
```

### Check grains

While grains are nearly never the source of issue in Banquise, it can be checked the same way than pillars using:

``` bash
salt 'management1*' grains.items
```

Note that this command is useful to get data of a specific minion.

## Check states

If data (pillars and grains) is not source of the issue state generating the error must be investigated.

States can fail during their tasks executions, or during a rendering of a jinja template.

### Debugging tasks

A task can fail during its own rendering, or during it's execution.

First part to check is the rendering, and the resulting task that is then executed. There are 2 ways to do this.

First, using salt-call -l debug, at beginning of execution, Salt will display the rendered content of each task executed.
While this is the simplest way to get the rendered task, the second way is more accurate.

Second way is to use the dumb.sls provided state, and copy content of your faulty state into the dumb.jinja file.
Then, execute the dumb state on a minion, using from the minion:

``` bash
salt-call state.apply dumb
```

And content of the /root/dumb file is the rendered state. It is then possible to check content for issues.

### Debugging templates

If issue occur while rendering a template file (a jinja2 template), standard code debugging strategy can be used.

Investigate error, and if Salt report is not enough, use brute force (remove part of template, check if error occur, if yes remove another part until you find what is generating the issue, etc).
