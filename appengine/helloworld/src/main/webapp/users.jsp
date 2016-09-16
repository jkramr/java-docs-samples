<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="com.example.appengine.helloworld.Guest" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
        pageContext.setAttribute("user", user);
%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
    to include your name with greetings you post.</p>
<%
    }
%>

<%
      List<Guest> guests = ObjectifyService.ofy()
          .load()
          .type(Guest.class)
          .limit(5)
          .list();

    if (guests.isEmpty()) {
%>
<p>No records.</p>
<%
    } else {
%>
<p>Users: </p>
<table>
    <tr>
        <th>ID</th>
        <th>email</th>
        <th>Name</th>
    </tr>
        <%
        for (Guest guest : guests) {
            pageContext.setAttribute("guest_id", guest.id);
            pageContext.setAttribute("guest_nickname", guest.name);
            String author;
            if (guest.email == null) {
                author = "<anonymous>";
            } else {
                author = guest.email;
            }
            pageContext.setAttribute("guest_email", author);
%>
    <tr>
        <td>${fn:escapeXml(guest_id)}</td>
        <td>${fn:escapeXml(guest_email)}</td>
        <td>${fn:escapeXml(guest_nickname)}</td>
    </tr>
<%
        }
    }
%>
</table>

<form action="/sign" method="post">
    <div><input type="text" name="nickname" rows="3" cols="60"></div>
    <div><input type="submit" value="Add guest"/></div>
</form>

</body>
</html>