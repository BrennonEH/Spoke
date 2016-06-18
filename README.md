# Spoke
Spoke is a webhooks library designed to be implemented in your current service application.

Current Version: 0.09.2

###Documentation###

- XML Comments - Most if not all of the methods in the codebase have been XML commented.

### Getting Started

1. Edit SQL script with desired schema name and database name. Use Find and Replace function
of your text editor.

2. Create a local instance of SQL Server [1] or from an existing database, execute the
SQL script [2] to create the tables.

3. Open the Spoke.sln solution file. 

4. In Spoke.Demo project, edit Program.cs to be same schema name as defined in step 1.

5. Edit the connection string [3] in the App.config file of the Spoke.Demo project.

6. Add references to Newtonsoft.Json and Topshelf to both Spoke and Spoke.demo 
projects. Check App.config for version numbers and .NET target framework number.

7. Build and run.

8. Visit localhost:<port>/ApiExplorer/ to exercise services.

### Description of files
`spoke-schema-sql-server.sql`

*Template* SQL script. The substitutions are $DB_NAME for the database and 
$SCHEMA_NAME for the schema. Use Find and Replace of your text editor.
	
### Notes

[1]: With sqllocaldb in Command Prompt, you can do
```
> sqllocaldb create spoke1 -s
```
[2]: In SQL Server Management Studio, you can connect with (LocalDb)\spoke1 as server name.  
[3]: Here is a sample connection string:
```xml
...
<connectionStrings>
	<add name="spoke" connectionString="Data Source=(LocalDb)\spoke1;Integrated Security=True;Database=spoke;" providerName="System.Data.SqlClient"/>
</connectionStrings>
...
```

There will be improvements and additions to the documentation as the project progresses.

###License###

The MIT License (MIT)

Copyright (c) 2016 Ambit Energy. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
