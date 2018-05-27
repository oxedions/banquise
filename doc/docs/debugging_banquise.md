# Debugging Banquise

Banquise is fully based on Salt Stack.

To debug Banquise, please understand the rendering order of Salt, and then use the provided debugging information below to investigate the faulty part. The global strategy is to identify which step is failing, and then use logs and test samples to solve issue.


## Salt rendering order

pillars -> top.sls pillars (who can access which pillars) -> top.sls states (who apply which states) -> states -> finalize with grains -> apply

## Gather information

When having an issue, best way if issue is not clearly specify is to check all elements one by one.

Pillars can be rendered on a specific target to display their content.
For example, to ask Salt to render management1 pillars, and display them:

salt 'management1*' pillar.items

First thing is then to scroll at the top of the output and check their is no errors, like:

_errors:
    - Rendering Primary Top file failed, render error:

or

_errors:
    - Rendering SLS 'engine/engine_connect' failed. Please see master log for details.

Then, if error is not display here, check master logs at /var/log/salt/master. For example, content can be:

ParserError: while parsing a block mapping
  in "<string>", line 15, column 2:
     dhcp_server:
     ^
expected <block end>, but found '<block mapping start>'
  in "<string>", line 17, column 4:
       management: auto
       ^

; line 5





To get more information, use:
salt-call -l trace

Recommended is:
salt-call -l debug

salt 'management1*' grains.items

## Debugging pillars

## Debugging states

## Debugging templates
