/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Default.class.hpp                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/09 12:36:57 by jeportie          #+#    #+#             */
/*   Updated: 2025/04/09 12:45:48 by jeportie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef DEFAULT_CLASS_HPP
# define DEFAULT_CLASS_HPP

# include <iostream>

class Default
{
public:
	Default(void);
	Default(int const fooNb);
	Default(Default const & src);
	~Default(void);

	Default & operator=(Default const & rhs);

	int getFoo(void) const;
	std::string	toString(void) const; //serialise class to string

private:
	int _foo;
};

// Overload operator<< for output streaming
std::ostream & operator<<(std::ostream & out, Default const & in);

#endif  // ************************************************ DEFAULT_CLASS_HPP //
