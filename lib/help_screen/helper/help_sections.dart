import 'package:flutter/cupertino.dart';

class CourseModel {
  String name;
  String description;
  String university;
  String noOfCource;
  String tag1;
  String tag2;
  IconData symbol;

  CourseModel({
    this.name,
    this.description,
    this.noOfCource,
    this.university,
    this.tag1,
    this.tag2,
  });
}

class CourseList {
  static List<CourseModel> list = [
    CourseModel(
        name: "Explore",
        description:
            "Find the perfect frame for your images here. Use the filter buttons on the top row to narrow your search to your aesthetic, whether its minimalistic or street-style graffiti."
            "\nShortlist your favourite frames by tappoing the ♥ icon and save the frames to your Liked collection.",
        tag1: "#findyourframe",
        tag2: "#submitaframe"),
    CourseModel(
        name: "Liked Collection",
        description:
            "A collection curated by just by you. This is where you'll the frames you've liked for your ease."
            "Tap the ♥ button to unlike a frame and remove it from your collection.",
        tag1: "#curated",
        tag2: "#doubletapthat"),
    CourseModel(
        name: "Creating a Grid",
        description: "1. Tap on a frame. "
            "\n2. Add your photos."
            "\n3. Rearrange the photos on the grid by dragging a photo"
            "\n4. Click Finish and see the magic!"
            "\n5. Choose what you want to do with your frames: "
            "\n   Post the frames directly to Instagram "
            "\n   To plan your posts in advance, be sure to tap the 'Add To My Grids' button and save your frames! "
            "\nGo to 'My Grids' after adding your frames and get started planning.",
        tag1: "#lifehacks",
        tag2: "#frameyourlife"),
    CourseModel(
        name: "Adding Your Grid To Instagram",
        description:
            "Once you've created a grid, you can directly post all 9 photos to Instagram by clicking on the 'Share to Instagram' button."
            "On this page, tap each photo in the order they're numbered in. A little pop-up will guide you to add it to your feed, story or slide into DMs.",
        tag1: "#dontwait",
        tag2: "#manageyourinsta"),
    CourseModel(
        name: "My Grids",
        description:
            "Want to see how your insta feed will look like before posting? Now you can!"
            "\n1. Tap a frame"
            "2. In the pop-up, click 'Schedule Post' and get reminder notifications! Be sure to enter a caption that you can simply-copy paste for when you post!"
            "3. View all your planned posts and modify them in the 'Calendar' page.",
        university: "Preview",
        noOfCource: "10 courses",
        tag1: "#preview",
        tag2: "#planyourinsta"),
    CourseModel(
        name: "Calendar",
        description: "A monthly preview of your next Instagram posts! "
            "\nDates with ● have posts planned. Each ● represents a post."
            "\nTap a date to see the list of posts planned. To update a reminder, click on a list item. Once you're done posting it, be sure to tick it off the list."
            "\nHad a busy day and forgot to post?! Fret not, simply modify the reminder for another day. Edit the caption if you need to as well.",
        tag1: "#planmyposts",
        tag2: "#captionme"),
  ];
}