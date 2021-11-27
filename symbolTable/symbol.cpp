#include <iostream>
#include <vector>
#include <map>
using namespace std;


class Node 
{

	string identifier, scope, type,var_address; 
	int lineNo;
	Node* next;

    public:
        Node()
        {
            next = NULL; 
        }
        //     init
        Node(string key, string value, string type, string var_address, int lineNo) 
        {
            this->identifier = key;
            this->scope = value;
            this->type = type;
            this->lineNo = lineNo;
            this->var_address = var_address;
            next = NULL;
        }

        void print()
        {
            cout << "Identifier's Name:" << identifier
                << "\nType:" << type
                << "\nScope: " << scope
                << "\nLine Number: " << lineNo
                << "\nAddress: " << var_address <<endl;
        }
        // making it a friend class so that it can access its private , protected and public members
        friend class Symbol_Table;
};

class Symbol_Table 
{
	vector<Node*>table;     // Main hash-table
    map<pair<string,string> ,bool>duplicate_check;  // To avoid duplicate variable names 

public:
	Symbol_Table()
	{
        for (int i = 0; i < 100; i++)
            table.push_back(NULL);
	}


    //this functions hashes the key value and generates a slot position 
    // in the hash map 
	int hash_function(string id)
    {
        int hash_value = 0;

        for (int i = 0; i < id.length(); i++) 
        {
            //using a prime number as a factor to avoid collision
            // and making the hash value a little sparsed in terms
            // of mod values in the main hash map vector
            hash_value = hash_value + id[i]*31;
        }

        return (hash_value % 100);
    }

    // for insertiing the values in the symbol table/hashmap
	bool insert(string id, string scope, string Type, string var_address, int lineno)
    {
        int index = hash_function(id);
        Node* p = new Node(id, scope, Type, var_address, lineno);

        pair<string,string>  tp = make_pair(id, scope);
        
        if(!duplicate_check[tp])   // checking for duplicacy
        {
            duplicate_check[tp] = true;
            if (table[index] == NULL)  // if there was no initial node present
            {
                table[index] = p;
                cout << "\n"<< id << " inserted";

                return true;
            }

            else 
            {
                Node* start = table[index];
                while (start->next != NULL)
                {
                    start = start->next;
                }
                start->next = p;
                cout << "\n"<< id << " inserted";
                return true;
            }
        }
        return false;
    }



    //for finding the node according to the given id
	string find(string id)
    {
        int index = hash_function(id);
        Node* start = table[index];

        if (start == NULL)  // If the node is not present
        {    
            return "-1";
        }

        while (start != NULL) 
        {

            if (start->identifier == id)   // If you found the node
            {
                start->print();
                return start->scope;
            }

            start = start->next;
        }

        return "-1"; 
    }


    // for deleting a record according to the give identifier.
	bool deleteRecord(string id)
    {
        int index = hash_function(id);
        Node* temp = table[index];
        Node* parent = table[index];

        if (temp == NULL)    //  If the node was not found
        {
            return false;
        }

        if (temp->identifier == id && temp->next == NULL)     // If only one node was found at that position
        {
            duplicate_check[(make_pair(temp->identifier,temp->scope))]=false;
            delete temp;
            table[index] = NULL;
            return true;
        }

        while (temp->identifier != id && temp->next != NULL)   // Searching the chain until the identifier is found
        {
            parent = temp;
            temp = temp->next;
        }
        if (temp->identifier == id && temp->next != NULL)   // If found
        {
            duplicate_check[(make_pair(temp->identifier,temp->scope))]=false;
            parent->next = temp->next;
            temp->next = NULL;
            delete temp;
            return true;
        }
        else 
        {
            duplicate_check[(make_pair(temp->identifier,temp->scope))]=false;
            parent->next = NULL;
            temp->next = NULL;
            delete temp;
            return true;
        }
        return false;
    }


    // for modifying a particular node , when asked for.
	bool update_record(string id, string s, string t, string a, int l)
    {
        int index = hash_function(id);
        Node* start = table[index];

        if (start == NULL)    // If the node is not found
            return false;

        while (start != NULL) 
        {
            if (start->identifier == id) 
            {
                start->scope = s;
                start->type = t;
                start->lineNo = l;
                start->var_address = a;
                return true;
            }
            start = start->next;
        }

        return false; 
    }


};


//END OF CLASS


int main()
{
	Symbol_Table st;
	cout << "\n\n** SYMBOL TABLE **\n\n";

    while(1)
    {
        string inp;
        string id,type,scope,var_address;
        int line_number;
        cout<<"Enter the action you want to do with the SYMBOL TABLE: insert, update, delete, find , exit\n\n";
        cin>>inp;

        if(inp == "insert")
        {

            cout<<"\nEnter the Identifier,Scope,Type,Address and the line number:\n\n";
            cin>>id>>scope>>type>>var_address>>line_number;
            if (st.insert(id, scope, type, var_address, line_number))
                cout << " -successfully\n\n";
            else
                cout << "\nFailed to insert.\n\n";

        }
        else if(inp == "delete")
        {
            
            cout<<"\nEnter the id of the identifier to be deleted:\n\n";
            cin>>id;
            cout<<'\n';
            if (st.deleteRecord(id))
                cout << id<< " Identifier is deleted\n\n";
            else
                cout << "\nFailed to delete\n\n";

        }
        else if(inp == "update")
        {
            cout<<"\nEnter the Old Identifier and the new Scope,Type, Address and the line number:\n\n";
            cin>>id>>scope>>type>>var_address>>line_number;
            cout<<"\n";
            if (st.update_record(id, scope, type, var_address, line_number))
                cout << id <<" updated successfully!\n\n";
            else
                cout << "\nFailed to update record.\n\n";
        }
        else if(inp == "find")
        {
            cout<<"\nEnter the id of the identifier that is to be found:\n\n";
            cin>>id;
            cout<<'\n';
            if(st.find(id) != "-1")
                cout << "Identifier Is present\n\n";
            else
                cout << "\nIdentifier Not Present\n\n";
        }
        else if(inp == "exit")
        {
            cout<<"\n\n";
            break;
        }
        else
        {
            cout<<"\nInvalid input. Try Again!\n\n";
        }

    }

	return 0;
}