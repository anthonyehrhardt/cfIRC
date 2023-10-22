<!--- Function to receive messages from the server --->
<cffunction name="receive_messages" access="public" returntype="void">
    <cfargument name="client_socket" type="any">
    
    <cfloop condition="true">
        <cftry>
            <cfset message = client_socket.recv(1024)>
            <cfif message neq "">
                <cfoutput>#message#</cfoutput>
            <cfelse>
                <cfoutput>Connection lost.</cfoutput>
                <cfbreak>
            </cfif>
            <cfcatch></cfcatch>
        </cftry>
    </cfloop>
</cffunction>

<!--- Main function to start the client --->
<cffunction name="main" access="public" returntype="void">
    <cfset client = createObject("java", "java.net.Socket").init("127.0.0.1", 6667)>
    
    <cfthread action="run" name="receive_thread">
        <cfset receive_messages(client)>
    </cfthread>

    <cfloop condition="true">
        <cfset message = inputBox("Enter your message (type '/quit' to exit):")>
        <cfif message eq "/quit">
            <cfset client.send(message)>
            <cfbreak>
        <cfelse>
            <cfset client.send(message)>
        </cfif>
    </cfloop>
</cffunction>

<!--- Start the client --->
<cfset main()>
