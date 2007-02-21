<%@ tag body-content="empty" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="app" uri="com.zimbra.htmlclient" %>
<%@ taglib prefix="zm" uri="com.zimbra.zm" %>


<app:handleError>
<c:choose>
    <c:when test="${not empty param.actionSave}">
        <c:set var="folder" value="${zm:getFolder(pageContext, param.folderId)}"/>
        <c:choose>
            <c:when test="${not empty param.folderNameVisible and empty param.folderName}">
                <app:status style="Warning">
                    <fmt:message key="actionNoCalendarNameSpecified"/>
                </app:status>
            </c:when>
            <c:when test="${not empty param.folderUrlVisible and empty param.folderUrl}">
                <app:status style="Warning">
                    <fmt:message key="actionNoCalendarUrlSpecified"/>
                </app:status>
            </c:when>
            <c:otherwise>
                <zm:updateFolder
                        id="${param.folderId}"
                        name="${param.folderName}"
                        color="${param.folderColor}"
                        flags="${param.folderExcludeFlag}${param.folderCheckedFlag}"/>
                <c:if test="${not empty param.folderUrl and param.folderUrl ne folder.remoteURL}">
                    <zm:modifyFolderUrl id="${param.folderId}" url="${param.folderUrl}"/>
                </c:if>
                <app:status>
                    <fmt:message key="calendarUpdated"/>
                </app:status>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:when test="${not empty param.actionNew}">
         <c:choose>
            <c:when test="${empty param.newFolderName}">
                <app:status style="Warning">
                    <fmt:message key="actionNoCalendarNameSpecified"/>
                </app:status>
            </c:when>
            <c:when test="${not empty param.newFolderUrlVisible and empty param.newFolderUrl}">
                <app:status style="Warning">
                    <fmt:message key="actionNoCalendarUrlSpecified"/>
                </app:status>
            </c:when>
             <c:when test="${not empty param.newFolderOwnersEmailVisible and empty param.newFolderOwnersEmail}">
                <app:status style="Warning">
                    <fmt:message key="actionNoOwnerEmailSpecified"/>
                </app:status>
            </c:when>
            <c:when test="${not empty param.newFolderOwnersCalendarVisible and empty param.newFolderOwnersCalendar}">
                <app:status style="Warning">
                    <fmt:message key="actionNoOwnerCalendarSpecified"/>
                </app:status>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${not empty param.newFolderOwnersEmailVisible}">
                        <zm:createMountpoint var="folder"
                                             parentid="1"
                                             name="${param.newFolderName}"
                                             view="appointment"
                                             color="${param.newFolderColor}"
                                             flags="${param.newFolderExcludeFlag}${param.newFolderCheckedFlag}"
                                             owner="${param.newFolderOwnersEmail}" ownerby="BY_NAME"
                                             shareditem="${param.newFolderOwnersCalendar}" shareditemby="BY_PATH"/>
                    </c:when>
                    <c:otherwise>
                        <zm:createFolder var="folder"
                                         parentid="1"
                                         name="${param.newFolderName}"
                                         view="appointment"
                                         color="${param.newFolderColor}"
                                         url="${param.newFolderUrl}"
                                         flags="${param.newFolderExcludeFlag}${param.newFolderCheckedFlag}"/>
                    </c:otherwise>
                </c:choose>
                <app:status>
                    <fmt:message key="actionCalendarCreated">
                        <fmt:param value="${param.newFolderName}"/>
                    </fmt:message>
                </app:status>
                <c:set var="newlyCreatedCalendarName" value="${param.newFolderName}" scope="request"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:when test="${not empty param.actionDelete}">
        <c:set var="folder" value="${zm:getFolder(pageContext, param.folderDeleteId)}"/>
        <c:choose>
            <c:when test="${empty param.folderDeleteConfirm}">
                <app:status style="Warning">
                    <fmt:message key="actionCalendarCheckConfirm"/>
                </app:status>
            </c:when>
            <c:otherwise>
                <c:set var="folderName" value="${folder.name}"/>
                <zm:deleteFolder id="${param.folderDeleteId}"/>
                <app:status>
                    <fmt:message key="actionCalendarDeleted">
                        <fmt:param value="${folderName}"/>
                    </fmt:message>
                </app:status>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>

    </c:otherwise>
</c:choose>
</app:handleError>

