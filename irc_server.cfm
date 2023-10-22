<!--- Create a list to hold connected clients --->
<cfset clients = []>

<!--- Function to broadcast messages to all connected clients --->
<cffunction name="broadcast" access="public" returntype="void">
    <cfargument name="message" type="string">
    <cfargument name="client_socket" type="any">
    
    <cfloop array="#clients#" index="client">
        <cfif client neq client_socket>
            <cftry>
                <cfset client.send(message)>
                <cfcatch></cfcatch>
            </cftry>
        </cfif>
    </cfloop>
</cffunction>

<!--- Function to handle client connections --->
<cffunction name="handle_client" access="public" returntype="void">
    <cfargument name="client_socket" type="any">
    
    <cfloop condition="true">
        <cftry>
            <cfset message = client_socket.recv(1024)>
            <cfif message neq "">
                <cfoutput>#client_socket.getpeername()#: #message#</cfoutput>
                <cfset broadcast(message, client_socket)>
            <cfelse>
                <cfset remove(client_socket)>
            </cfif>
            <cfcatch></cfcatch>
        </cftry>
    </cfloop>
</cffunction>

<!--- Function to remove a client from the list --->
<cffunction name="remove" access="public" returntype="void">
    <cfargument name="client_socket" type="any">
    
    <cfloop array="#clients#" index="client">
        <cfif client is client_socket>
            <cfset arrayDeleteAt(clients, arrayFind(clients, client))>
        </cfif>
    </cfloop>
</cffunction>

<!--- Main function to start the server --->
<cffunction name="main" access="public" returntype="void">
    <cfset server = createObject("java", "java.net.ServerSocket").init(6667)>
    
    <cfoutput>Server is listening for connections...</cfoutput>

    <cfloop condition="true">
        <cftry>
            <cfset client_socket = server.accept()>
            <cfset arrayAppend(clients, client_socket)>
            <cfthread action="run" name="client_thread">
                <cfset handle_client(client_socket)>
            </cfthread>
        <cfcatch></cfcatch>
        </cftry>
    </cfloop>
</cffunction>

<!--- Start the server --->
<cfset main()>
