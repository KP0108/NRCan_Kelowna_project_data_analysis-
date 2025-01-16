# NRCan_Kelowna_project_data_analysis

1.Heating permit data processing:


Data processing, merging, and text mining were applied to extract useful information in Kelowna's heating permits.
Dataset used: City of Kelowna’s Model City (City of Kelowna) data, B.C. Assessment (B.C. Assessment) data and Permit data
The heating permit data provides information about 1) permit applications for heating system changes (e.g., furnace, gas line, hot water tank) in a building, 2) application date per heating permit, and 3) associated work description. A unique permit number was assigned per activity, and hence, a building might have several permit numbers. This resulted in duplication/repetition of KID in the dataset, followed by a unique permit number.
The major challenge in extracting useful information from heating permits was the lack of clarity in work descriptions. Most work descriptions related to the replacement of furnaces and hot water tanks were mentioned as 'Re & Re furnace' and 'Re & Re HWT,' respectively. In some entries, the word 'furnace' was misspelled as 'furnance', and 'hot water tank' was abbreviated as 'HWT.'' Besides, 39% of heating permit work descriptions were empty (has missing values), and 8% of the work description had unclear abbreviations such as '@', '1', '40', '# G.C.', etc. The duplicated/repeated KIDs, missing cells, and unclear work descriptions made data analysis challenging. Another challenge was the lack of mechanical system type or efficiency, key attributes required by HOT2000.


The first step in processing heating permit data involved transposing all information related to a building KID in a single row. Data re-arrangement was done based on building KID and permit number. New attributes/labels were generated as a separate column created for each permit number, its associated work description, and permit application date. Subsequently, the recurrence of building KID in the dataset was avoided without any information being lost. The second step was refining information in the work description. Since explicit metadata was not available on work descriptions, some assumptions were made. For example, if a work description contained 'Re & Re furnace,' 'Re & Re HWT,' 'Re & Re Gas,' then it was assumed that an old mechanical system corresponding to the furnace, hot water tank (HWT), and gas, respectively, was removed and replaced. In this study, five keywords, namely furnace, HWT, gas, fireplace, and pool heater, were identified. Any work description containing these keywords was categorized under one of them. The five keywords were chosen considering their frequent appearance in the work description column and based on the inputs required by HOT2000.  Work descriptions that did not contain any of the five keywords were categorized as 'Others.' Once the heating permit dataset challenges were resolved, the next step entailed mapping processed heating permit data with Model City data based on building KID.


2.Data processing procedure for deriving the average daily heating, cooling setpoint temperature profile
Dataset used: ecobee data
Steps for thermostat setpoint temperature analysis are conversion of Fahrenheit to Celsius, data aggregation to obtain daily average temperature profiles for each house and filtration of HVAC modes. After conversion, data aggregation was performed at two levels. The first level involved aggregating 5-minute data into hourly data. The second level of data aggregation was performed based on the hour of the day, house ID, and HVAC mode to obtain the average 24h setpoint temperature profiles for each house, respectively. Later, data filtration was performed to account for houses with HVAC mode set to 'heat' and 'cool' rather than 'auto' or 'off'.  To derive the average daily heating and cooling setpoint temperature profiles, the average heating and cooling setpoint temperature data extracted for the HVAC mode 'heat' and 'cool' was considered for the analysis and the HVAC mode 'auto' and 'off' was excluded.
Once the average 24-h heating and cooling setpoint temperature profile for each house was obtained, k-means clustering was performed to extract different patterns of heating and cooling setpoint temperatures. The aim of the clustering analysis was to explore the distribution of house characteristics (number of storeys, floor area, and vintage) in each cluster and suggest appropriate heating and cooling setpoint temperature that shall be assigned to archetypes during housing energy simulation. The number of clusters 'k' was identified using the Dunn Index cluster validation index.


## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/KP0108/nrcan_kelowna_project_data_analysis.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/project/integrations/)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Automatically merge when pipeline succeeds](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://docs.gitlab.com/ee/user/application_security/sast/)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!).  Thank you to [makeareadme.com](https://gitlab.com/-/experiment/new_project_readme_content:d37e341c6f21139b3a28c924598ab895?https://www.makeareadme.com/) for this template.

## Suggestions for a good README
Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.

