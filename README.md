<div id="top"></div>

[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/miron-boiangiu/image-processor">
    <img src="images/logo.png" alt="Logo" width="120" height="120">
  </a>

<h3 align="center">Java File Merger</h3>

  <p align="center">
    A Bash script used to merge all .java files in the current folder and subfolders into a single file.
    <br />
    <br />
    <a href="https://github.com/miron-boiangiu/image-processor/issues">Report Bug</a>
    ·
    <a href="https://github.com/miron-boiangiu/image-processor/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

A Bash script used to merge all .java files in the current folder and subfolders into a single file, it was conceived to be used on sites such as LeetCode and LambdaChecker.


### Built With

* [Bash](https://www.gnu.org/software/bash/)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- USAGE EXAMPLES -->
## Usage

Suppose we have the following file hierarchy:

```
├── project_root
│   ├── file1.java
│   ├── file2.java
│   ├── test_folder
│   │   ├── test_folder2
│   │   │   └── file4.java
└── └── └── file3.java
```

By running the script from the root of the project (project_root), a new file is created, named _single_script.java_, the script attempts to determine which imports to keep (which packages refer to the current project), which class to mark as public and the correct package name for the location of the new script. It parses all .java files in the project's folder and subfolders. The hierarchy will now look like this:

```
├── project_root
│   ├── single_script.java
│   ├── file1.java
│   ├── file2.java
│   ├── test_folder
│   │   ├── test_folder2
│   │   │   └── file4.java
└── └── └── file3.java
```
All files that are parsed (_file*.java_ for this example) remain unmodified, with single_script.java containing all of their logic. The new file's name does not correspond to its public class so as not to modify source files.

<br>

**Small note**: if you plan on using the new file's contents on sites such as LeetCode or LambdaChecker, make sure to remove the "package _package\_name_;" line from it, as it can break them.


<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONTACT -->
## Contact

Boiangiu Victor-Miron - miron.boiangiu@gmail.com

Project Link: [https://github.com/miron-boiangiu/oop_merge_script](https://github.com/miron-boiangiu/oop_merge_script)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/miron-boiangiu/oop_merge_script.svg?style=for-the-badge
[contributors-url]:https://github.com/miron-boiangiu/oop_merge_script/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/miron-boiangiu/oop_merge_script.svg?style=for-the-badge
[forks-url]:https://github.com/miron-boiangiu/oop_merge_script/network/members
[stars-shield]: https://img.shields.io/github/stars/miron-boiangiu/oop_merge_script.svg?style=for-the-badge
[stars-url]:https://github.com/miron-boiangiu/oop_merge_script/stargazers
[issues-shield]: https://img.shields.io/github/issues/miron-boiangiu/oop_merge_script.svg?style=for-the-badge
[issues-url]:https://github.com/miron-boiangiu/oop_merge_script/issues
[license-shield]: https://img.shields.io/github/license/miron-boiangiu/oop_merge_script.svg?style=for-the-badge
[license-url]:https://github.com/miron-boiangiu/oop_merge_script/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/miron-boiangiu/
[product-screenshot]: images/screenshot.png
