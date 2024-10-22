# HiGlass Data Pipeline with Flask and Docker

## Description
This project enhances the HiGlass genome visualization tool by providing a seamless data pipeline for configuring, executing, and managing visualizations. The pipeline is integrated with a web interface built using Flask and deployed via Docker, allowing users to easily generate and view complex genome data plots on both Windows and Linux environments. The solution improves user experience by automating intermediate data file movement and ensuring efficient resource cleanup. The project was designed to work with Windows WSL and leverages the existing infrastructure to create a robust, accessible solution.

## Features
Cross-Platform Support: Works seamlessly on both Linux and Windows (via WSL). <br/>
Integrated Data Pipeline: Automates the configuration, file movement, and result organization for HiGlass visualizations. <br/>
Web-Based Interface: Provides an intuitive Flask-based web UI for easier interaction with HiGlass. <br/>
Dockerized for Ease of Deployment: The project is containerized, ensuring that the necessary components work together seamlessly. <br/>
Resource Management: Automatically handles cleanup of intermediate files and manages output for easier archival and search. <br/>
Windows Compatibility: Edited HiGlass to work within a Windows environment via PowerShell. <br/>
