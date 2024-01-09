#pragma once
#include "SyntaxTree.hpp"
namespace compiler{

	class Funtion : public SyntaxTree{
		public:
			Funtion (SyntaxTree *name, SyntaxTree *statement){

				children.push_back(name);
				children.push_back(statement);
			}
			virtual ~Funtion(){}
			virtual std::string toCode() const {
				std::string code;
				code += "#include <stdio.h>\n";
				code += "int main (){";
				for(SyntaxTree *node : children){
					if(node != nullptr){
		//std::cout << "Funtion children: " << node << std::endl;
		code += node->toCode();
					}
				}
				code += "}";
				return code;

			}
	};


}
