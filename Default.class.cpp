/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Default.class.cpp                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/09 12:37:57 by jeportie          #+#    #+#             */
/*   Updated: 2025/04/09 12:44:47 by jeportie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <iostream>
#include <ostream>
#include <sstream>
#include "Default.class.hpp"

Default::Default(void)
: _foo(0)
{
    std::cout << "Default constructor called" << std::endl;
    return;
}

Default::Default(int const fooNb)
: _foo(0)
{
    std::cout << "Parametric constructor called" << std::endl;
    return;
}

Default::Default(Default const& src)
{
    std::cout << "Copy constructor called" << std::endl;
    *this = src;
    return;
}

Default::~Default(void)
{
    std::cout << "Default constructor called" << std::endl;
    return;
}

Default & Default::operator=(Default const & rhs)
{
    std::cout << "Assignement operator called" << std::endl;
	if (this != &rhs)
		this->_foo = rhs.getFoo();
	return (*this);

}

std::ostream &	operator<<(std::ostream & out, Default const & in)
{
	out << "The value of _foo is : " << in.getFoo();
	return (out);
}

int Default::getFoo(void) const { return (_foo); }

std::string Default::toString(void) const
{
    std::ostringstream oss;
    oss << "Default(_foo=" << _foo << ")";
    return (oss.str());
}
