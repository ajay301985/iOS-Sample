# iOS-Sample

## ASSIGNMENT

Develop a simple application connected to the Unsplash API
(https://unsplash.com/developers) that displays the search results in a grid view with
expendable thumbnails using modern best practices and latest technologies. This
assignment shall be presented in English.

## App Use cases
1: On application launch app fetch the photo results using unspash API, default query is "nature" and item count set to 30.\
2: Item height is dynamic based on the image \
3:On click on image, item expand to show the information about image description (2 line max) and user name in "Clicked by: <user name>" and on clicking again on same image it will collapse the item and hide the information.

## Configuration
To configure the page number and item count and query, following variable need to change in ViewController class\

 ####  private let queryString = "nature"
 ####  private let currentPage = 1
 ####  private let itemCount = 30

  
## Technical specification

Project is built using MVVM design pattern and following is the description for major classes

### Classes
ViewController.swift - controller class having two view HeaderView and CollectionView. Getting all the data from PhotoViewModel class and communicating with ImageDownloader to get the images from server or cache. This class also manage the datasource and delegation for collection view\
PhotoViewModel - This class get the data from PhotoService class and pass the data to controller class\
Photo - Model class and this contain all the models required for this application.\
ImageDownloader - Download image from server and cache the images in Cache to avoid redownloading every time\
PhotoCollectionCellLayout: Collection cell layout class defining cell layout based on dynamic size.

