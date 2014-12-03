#!/usr/bin/python

import os

import yaml


def get_autoupdate_projects(jjb_dir, projects):
    """Get list of projects that should be auto-updated."""
    project_list = []
    for project in projects:
        template = os.path.join(jjb_dir, project, "%s.yaml" % project)
        if os.path.isfile(template):
            with open(template, 'r') as f:
                first_line = f.readline()
            if first_line.startswith("# REMOVE THIS LINE IF"):
                project_list.append(project)

    return project_list


def update_templates(projects):
    for project in projects:

        # If project has customized variables
        cfg_file = "jjb/%s/%s.cfg" % (project, project)
        parameters = ["python scripts/jjb-init-project.py"]
        if os.path.isfile(cfg_file):
            stream = open(cfg_file, "r")
            cfg = yaml.load(stream)
            for k, v in cfg.items():
                if k == "MVN_GOALS" and v is not None:
                    parameters.append("-g '%s'" % v)
                elif k == "MVN_OPTS" and v is not None:
                    parameters.append("-o '%s'" % v)

            parameters.append(project)
            cmd = " ".join(parameters)
            os.system(cmd)

        else:
            os.system("python scripts/jjb-init-project.py %s" % project)

##############
# Code Start #
##############

jjb_dir = "jjb"
all_projects = [d for d in os.listdir(jjb_dir)
                if os.path.isdir(os.path.join(jjb_dir, d))]
auto_update_projects = get_autoupdate_projects(jjb_dir, all_projects)
update_templates(auto_update_projects)
