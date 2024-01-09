#pragma once
#include "SyntaxTree.hpp"

namespace compiler{

	class Input : public SyntaxTree
	{
		public:
			Input(SyntaxTree *funtion, SyntaxTree *funtions)
			{
			children.push_back(funtion);
			children.push_back(funtions);
			}
			virtual ~Input(){}
			virtual std::string toCode() const{
			std::string code;
			for(SyntaxTree *node: children){
				if(node != nullptr){
		//std::cout <<"Input child" << node << std::endl;
		code += node->toCode();
				}
			}
			return code;
		}
	};

}
